{ inputs, lib, ... }:
let
  # The last part of the drive id corresponds to the physical serial number
  drive_id = "ata-Samsung_SSD_860_EVO_500GB_S3Z2NB1KA98698A";
  drive_link = "/dev/disk/by-id/${drive_id}";
in {

  # Import generic hardware configuration
  imports = [
    inputs.hardware.nixosModules.common-pc
    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-pc-ssd
    inputs.hardware.nixosModules.common-hidpi
    inputs.impermanence.nixosModules.impermanence
  ];

  # nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  boot.initrd.availableKernelModules = [
    "ahci"
    "xhci_pci"
    "nvme"
    "sd_mod"
    "usbhid"
    "usb_storage"
  ];
  boot.kernelModules = [ "kvm-amd" ];

  hardware.enableAllFirmware = lib.mkDefault true;

  boot.initrd.luks.devices."luks".device = "/dev/disk/by-partlabel/root";

  fileSystems = {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = [ "size=2G" "mode=755" ];
    };
    "/home" = {
      device = "/dev/disk/by-partlabel/root";
      fsType = "btrfs";
      options = [ "subvol=home" "compress=zstd" "noatime" ];
    };
    "/nix" = {
      device = "/dev/disk/by-partlabel/root";
      fsType = "btrfs";
      options = [ "subvol=home" "compress=zstd" "noatime" ];
    };
    "/persist" = {
      device = "/dev/disk/by-partlabel/root";
      fsType = "btrfs";
      options = [ "subvol=home" "compress=zstd" "noatime" ];
      neededForBoot = true;
    };
    "/boot" = {
      device = "/dev/disk/by-partlabel/boot";
      fsType = "vfat";
    };
  };

  environment.persistence."/persist/system" = {
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"
    ];
    files = [
      "/etc/machine-id"
      { file = "/etc/nix/id_rsa"; parentDirectory = { mode = "u=rwx,g=,o="; }; }
    ];
  };

    # users.talyz = {
    #   directories = [
    #     "Downloads"
    #       "Music"
    #       "Pictures"
    #       "Documents"
    #       "Videos"
    #       "VirtualBox VMs"
    #       { directory = ".gnupg"; mode = "0700"; }
    #   { directory = ".ssh"; mode = "0700"; }
    #   { directory = ".nixops"; mode = "0700"; }
    #   { directory = ".local/share/keyrings"; mode = "0700"; }
    #   ".local/share/direnv"
    #   ];
    #   files = [
    #     ".screenrc"
    #   ];
    # };

  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 20480;  # 20GB
    }
  ];

}
