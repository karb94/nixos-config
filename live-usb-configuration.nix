# General configuration
{
  inputs,
    lib,
    pkgs,
    ...
}: {

  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-base.nix>
  ];

  hardware.enableAllFirmware = true;
  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    # Enable flakes and new 'nix' command
    experimental-features = ["nix-command" "flakes"];
    # Deduplicate and optimize nix store
    auto-optimise-store = true;
  };

  # Networking
  networking.hostName = "live-usb";
  networking.useDHCP = lib.mkDefault true;
  # Disable wpa_supplicant which is enabled by the imports
  networking.wireless.enable = false;
  # Enable NetworkManager with iwd wifi backend
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.backend = "iwd";

  # Locale
  i18n.supportedLocales = [
    "en_GB.UTF-8/UTF-8"
    "es_ES.UTF-8/UTF-8"
    "ca_ES.UTF-8/UTF-8"
  ];
  i18n.defaultLocale = "en_GB.UTF-8";

  isoImage.volumeID = lib.mkForce "id-live";
  isoImage.isoName = lib.mkForce "id-live.iso";

  environment.systemPackages = with pkgs; [
    neovim
    bottom
    coreutils
    findutils
    git
    lf
    ripgrep
    tree
    bitwarden-cli
  ];

  environment.etc."install.sh" = {
    enable = true;
    user = "root";
    mode = "0700";
    text = ''
    #! /usr/bin/env bash

    # exit when any command fails
    set -e

    # Connect to the wifi network
    printf "\n\nConnecting to '3C9C 5Ghz' Wifi\n"
    nmcli --ask device wifi connect '3C9C 5Ghz'
    while [ $? -ne 0 ]
    do
      printf "\n\nIncorrect password. Try again.\n"
      nmcli --ask device wifi connect '3C9C 5Ghz'
    done

    # Capture disk names into the "disks" Bash array
    mapfile -t DISKS < <(
      lsblk --output NAME,TYPE --noheadings --list |
        awk '$2 == "disk" {print $1}'
    )

    while true
    do
      # Print device information
      lsblk -o NAME,SIZE,LABEL,PARTLABEL,FSTYPE,MOUNTPOINTS
      # Prompt the selection of the device
      PS3="Select a disk: "
      select DISK in ''${DISKS[@]}; do break; done;
      # Prompt confirmation
      printf "\nYou selected disk \"$DISK\"\n\n"
      lsblk -o NAME,SIZE,LABEL,PARTLABEL,FSTYPE,MOUNTPOINTS "/dev/$DISK"
      printf "\n"; read -p "Confirm your selection (y/n): " -n 1 -r; printf "\n\n"
      if [[ $REPLY =~ ^[Yy]$ ]]; then break; fi;
    done

    DEVICE="/dev/$DISK"

    printf "\n\nWiping $DISK disk\n"
    wipefs --all --force $DEVICE

    BOOT_PART_NUM=1
    ROOT_PART_NUM=2
    # Create boot and root partitions and add correct types and partlabels
    printf "\n\nCreating boot and root partitions in $DEVICE\n"
    sgdisk \
      -n "$BOOT_PART_NUM"::+500M \
      -t "$BOOT_PART_NUM":ef00   \
      -c "$BOOT_PART_NUM":"boot" \
      -n "$ROOT_PART_NUM"::0     \
      -t "$ROOT_PART_NUM":8304   \
      -c "$ROOT_PART_NUM":"root" \
      -p "$DEVICE"

    BOOT_DEVICE="$DEVICE$BOOT_PART_NUM"
    ROOT_DEVICE="$DEVICE$ROOT_PART_NUM"
    LUKS_NAME="luksroot"
    LUKS_DEVICE="/dev/mapper/$LUKS_NAME"
    LUKS_TOP_LEVEL="/tmp/root"

    printf "\n\nEncrypting root partition with LUKS\n"
    cryptsetup -v luksFormat "$ROOT_DEVICE"
    printf "\n\nOpening encrypted partition and mapping it to "$LUKS_NAME"\n"
    cryptsetup -v open "$ROOT_DEVICE" "$LUKS_NAME"

    printf "\n\nCreating FAT32 (boot) and BTRFS (root) filesystems\n"
    mkfs.vfat "$BOOT_DEVICE"
    mkfs.btrfs "$LUKS_DEVICE"

    printf "\n\nMounting root tmpfs to /mnt\n"
    mount -t tmpfs none /mnt

    printf "\n\nMounting top-level BTRFS sub-volume to $LUKS_TOP_LEVEL\n"
    mkdir -pv /tmp/root
    mount "$LUKS_DEVICE" "$LUKS_TOP_LEVEL"
    printf "\n\nCreating BTRFS subvolumes\n"
    btrfs subvolume create "$LUKS_TOP_LEVEL/nix"
    btrfs subvolume create "$LUKS_TOP_LEVEL/persist"
    btrfs subvolume create "$LUKS_TOP_LEVEL/home"
    btrfs subvolume create "$LUKS_TOP_LEVEL/swap"

    printf "\n\nMounting boot partition and subvolumes\n"
    mkdir -vp /mnt/{boot,nix,persist,home,swap}
    mount "$BOOT_DEVICE" /mnt/boot
    mount -vo subvol=nix,compress=zstd,noatime "$LUKS_DEVICE" /mnt/nix
    mount -vo subvol=persist,compress=zstd,noatime "$LUKS_DEVICE" /mnt/persist
    mount -vo subvol=home,compress=zstd,noatime "$LUKS_DEVICE" /mnt/home
    mount -vo subvol=swap,compress=zstd,noatime "$LUKS_DEVICE" /mnt/swap

    printf "\n\nCreating /persist directories\n"
    mkdir -vp /mnt/persist/system/var/log
    mkdir -vp /mnt/persist/system/var/lib/{nixos,bluetooth,systemd/coredump}
    mkdir -vp /mnt/persist/system/etc/NetworkManager/system-connections
    mkdir -vp /mnt/persist/system/passwords

    printf "\n\nSet root password\n"
    mkpasswd -m SHA-512 > /mnt/persist/system/passwords/root
    printf "\n\nSet \"carles\" user password\n"
    mkpasswd -m SHA-512 > /mnt/persist/system/passwords/carles

    printf "\n\nInstalling NixOS\n"
    nixos-install --no-root-passwd --flake github:karb94/nixos-config#impermanence
    '';
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
