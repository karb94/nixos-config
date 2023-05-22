{ inputs, lib, ... }:
let
  luks_name = "luksroot";
  luks_device = "/dev/mapper/luksroot";
in {

  # Import generic hardware configuration
  imports = [
    inputs.hardware.nixosModules.common-pc
    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-pc-ssd
    inputs.hardware.nixosModules.common-hidpi
    inputs.impermanence.nixosModules.impermanence
    inputs.impermanence.nixosModules.home-manager.impermanence
  ];

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

  boot.initrd.luks.devices."${luks_name}".device = "/dev/disk/by-partlabel/root";

  fileSystems = {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = [ "size=6G" "mode=755" ];
      neededForBoot = true;
    };
    "/nix" = {
      device = luks_device;
      fsType = "btrfs";
      options = [ "subvol=nix" "compress=zstd" "noatime" ];
      neededForBoot = true;
    };
    "/persist" = {
      device = luks_device;
      fsType = "btrfs";
      options = [ "subvol=persist" "compress=zstd" "noatime" ];
      neededForBoot = true;
    };
    "/swap" = {
      device = luks_device;
      fsType = "btrfs";
      options = [ "subvol=swap" "compress=zstd" "noatime" ];
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

  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 20480;  # 20GB
    }
  ];

}
