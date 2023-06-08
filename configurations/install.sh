#! /usr/bin/env bash

# exit when any command fails
set -e

boot_device="/dev/disk/by-partlabel/boot"
root_device="/dev/disk/by-partlabel/root"
boot_part_num=1
root_part_num=2
luks_name="luksroot"
luks_device="/dev/mapper/$luks_name"
btrfs_top_level="/tmp/root"

# connect to the wifi network
wifi_connect() {
  printf "\n\nConnecting to '3C9C 5Ghz' wifi\n"
  nmcli --ask device wifi connect '3C9C 5Ghz'
  while [ $? -ne 0 ]
  do
    printf "\n\nIncorrect password. try again.\n"
    nmcli --ask device wifi connect '3C9C 5Ghz'
  done
}

# select a disk
choose_disk() {
  # capture disk names into the "disks" bash array
  mapfile -t disks < <(
  lsblk --output name,type --noheadings --list |
    awk '$2 == "disk" {print $1}'
  )
  while true
  do
    # print device information
    lsblk -o name,size,label,partlabel,fstype,mountpoints
    # prompt the selection of the device
    ps3="Select a disk: "
    select disk in ''${disks[@]}; do break; done;
      # prompt confirmation
      printf "\nYou selected disk \"$disk\"\n\n"
      lsblk -o name,size,label,partlabel,fstype,mountpoints "/dev/$disk"
      printf "\n"; read -p "confirm your selection (y/n): " -n 1 -r; printf "\n\n"
      if [[ $reply =~ ^[yy]$ ]]; then break; fi;
      done
      echo "/dev/$disk"
    }

# delete the partition table of a disk
wipe_disk() {
  local device="$1"
  printf "\n\nWiping $device disk\n"
  wipefs --all --force "$device"
}

# create boot and root partitions and add correct types and partlabels
partition_disk() {
  local device="$1"
  printf "\n\nCreating boot and root partitions in $device\n"
  sgdisk \
    -n "$boot_part_num"::+500m \
    -t "$boot_part_num":ef00   \
    -c "$boot_part_num":"boot" \
    -n "$root_part_num"::0     \
    -t "$root_part_num":8304   \
    -c "$root_part_num":"root" \
    -p "$device"
  }

  format_luks() {
    printf "\n\nEncrypting root partition with luks\n"
    cryptsetup -v luksFormat "$root_device"
    while [ $? -ne 0 ]
    do
      printf "\n\nIncorrect password. try again.\n"
      cryptsetup -v luksFormat "$root_device"
    done
  }

  open_luks() {
    printf "\n\nOpening encrypted partition and mapping it to "$luks_name"\n"
    cryptsetup -v open "$root_device" "$luks_name"
    while [ $? -ne 0 ]
    do
      printf "\n\nIncorrect password. try again.\n"
      cryptsetup -v open "$root_device" "$luks_name"
    done
  }

  format_partitions() {
    printf "\n\nCreating FAT32 (boot) and BTRFS (root) filesystems\n"
    mkfs.vfat "$boot_device"
    mkfs.btrfs "$luks_device"
  }

  create_subvolumes() {
    printf "\n\nMounting top-level btrfs sub-volume to $btrfs_top_level\n"
    mkdir -pv /tmp/root
    mount "$luks_device" "$btrfs_top_level"
    printf "\n\nCreating btrfs subvolumes\n"
    btrfs subvolume create "$btrfs_top_level/nix"
    btrfs subvolume create "$btrfs_top_level/persist"
    btrfs subvolume create "$btrfs_top_level/swap"
    printf "\n\nUnmounting top-level btrfs sub-volume\n"
    umount -v "$btrfs_top_level"
  }

  mount_partitions() {
    printf "\n\nMounting root tmpfs to /mnt\n"
    mount -t tmpfs none /mnt
    printf "\n\nMounting top-level btrfs sub-volume to $btrfs_top_level\n"
    mkdir -pv /tmp/root
    mount "$luks_device" "$btrfs_top_level"
    printf "\n\nMounting boot partition\n"
    mkdir -vp /mnt/boot
    mount -v "$boot_device" /mnt/boot
    printf "\n\nMounting BTRFS subvolumes\n"
    mkdir -vp /mnt/{nix,persist,swap}
    mount -vo subvol=nix,compress=zstd,noatime "$luks_device" /mnt/nix
    mount -vo subvol=persist,compress=zstd,noatime "$luks_device" /mnt/persist
    mount -vo subvol=swap,compress=zstd,noatime "$luks_device" /mnt/swap
    printf "\n\nCreating persist dirs\n"
    mkdir -vp /mnt/persist/{system,home}
  }

  create_passwords() {
    printf "\n\nSet \"carles\" user password\n"
    mkdir -vp /mnt/persist/system/passwords
    mkpasswd -m sha-512 > /mnt/persist/system/passwords/carles
    while [ $? -ne 0 ]
    do
      printf "\n\nIncorrect password. try again.\n"
      mkpasswd -m sha-512 > /mnt/persist/system/passwords/carles
    done
  }

  clone_dotfiles() {
    local dotfiles_path='/mnt/persist/home/carles/.config/dotfiles'
    local dotfiles_repo='https://github.com/karb94/dotfiles.git' 
    mkdir -vp "$dotfiles_path"
    git clone -b nixos --single-branch "$dotfiles_repo" "$dotfiles_path"
  }

  get_ssh_key() {
    local bw_session=$(bw unlock --raw)
    local id_ed25519_pub="/mnt/persist/home/carles/.ssh/id_ed25519.pub"
    local id_ed25519="/mnt/persist/home/carles/.ssh/id_ed25519"
    bw get notes "id_ed25519.pub" --session "$(bw_session)" > "$id_ed25519_pub"
    bw get notes "id_ed25519" --session "$(bw_session)" > "$id_ed25519"
    bw lock
    chown 1000:100 "$id_ed25519_pub"
    chown 1000:100 "$id_ed25519"
    chmod 644 "$id_ed25519_pub"
    chmod 600 "$id_ed25519"
  }

  install_nixos() {
    printf "\n\nInstalling nixos\n"
    nixos-install --no-root-passwd --flake 'github:karb94/nixos-config#impermanence'
  }

  format_disk() {
    local device=$1
    wipe_disk "$device"
    partition_disk "$device"
    format_luks
    open_luks
    format_partitions
    create_subvolumes
    mount_partitions
    create_passwords
    clone_dotfiles
    get_ssh_key
    chown -R 1000:100 /persist/home/carles
    install_nixos
  }
