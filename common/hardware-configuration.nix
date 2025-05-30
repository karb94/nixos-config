{
  inputs,
  lib,
  impermanence,
  ...
}: let
  luks_root_name = "luksroot";
  luks_root_device = "/dev/mapper/${luks_root_name}";
  luks_data1_name = "luksdata1";
  luks_data1_device = "/dev/mapper/${luks_data1_name}";
  luks_data2_name = "luksdata2";
  # luks_data2_device = "/dev/mapper/${luks_data2_name}";
in {
  # Import generic hardware configuration
  imports = [
    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-gpu-amd
    inputs.hardware.nixosModules.common-hidpi
    inputs.hardware.nixosModules.common-pc
    inputs.hardware.nixosModules.common-pc-ssd
    # inputs.impermanence.nixosModules.impermanence
  ];

  config = lib.mkMerge [
    {
      boot = {
        initrd.availableKernelModules = [
          "ahci"
          "xhci_pci"
          "nvme"
          "sd_mod"
          "usbhid"
          "usb_storage"
        ];
        kernelModules = [ "kvm-amd"];
        supportedFilesystems = [ "ntfs" ];
      };
      hardware.enableAllFirmware = lib.mkDefault true;
    }
    (
      lib.mkIf impermanence {
        boot.initrd.luks.devices = {
          "${luks_root_name}".device = "/dev/disk/by-partlabel/root";
          "${luks_data1_name}".device = "/dev/disk/by-label/data1";
          "${luks_data2_name}".device = "/dev/disk/by-label/data2";
        };
        fileSystems = {
          "/" = {
            device = "none";
            fsType = "tmpfs";
            options = ["size=12G" "mode=755"];
            neededForBoot = true;
          };
          "/nix" = {
            device = luks_root_device;
            fsType = "btrfs";
            options = ["subvol=nix" "compress=zstd" "noatime"];
            neededForBoot = true;
          };
          "/persist" = {
            device = luks_root_device;
            fsType = "btrfs";
            options = ["subvol=persist" "compress=zstd" "noatime"];
            neededForBoot = true;
          };
          "/data/documents" = {
            device = luks_data1_device;
            fsType = "btrfs";
            options = ["subvol=documents" "compress=zstd" "noatime"];
          };
          "/data/media" = {
            device = luks_data1_device;
            fsType = "btrfs";
            options = ["subvol=media" "compress=zstd" "noatime"];
          };
          # "/data/immich" = {
          #   device = luks_data1_device;
          #   fsType = "btrfs";
          #   options = ["subvol=immich" "compress=zstd" "noatime"];
          # };
          # "/data/paperless" = {
          #   device = luks_data1_device;
          #   fsType = "btrfs";
          #   options = ["subvol=paperless" "compress=zstd" "noatime"];
          # };
          "/boot" = {
            device = "/dev/disk/by-partlabel/boot";
            fsType = "vfat";
            options = [ "umask=0077" ];
          };
        };
        zramSwap = {
          enable = true;
          memoryMax = 8000000000;
        };
      }
    )
    (
      lib.mkIf (! impermanence) {
        boot.initrd.luks.devices = {
          "${luks_data1_name}".device = "/dev/disk/by-label/data1";
          "${luks_data2_name}".device = "/dev/disk/by-label/data2";
        };
        fileSystems = {
          "/" = {
            device = "/dev/disk/by-label/root";
            fsType = "ext4";
          };
          "/data/immich" = {
            device = luks_data1_device;
            fsType = "btrfs";
            options = ["subvol=immich" "compress=zstd" "noatime"];
          };
          "/boot" = {
            device = "/dev/disk/by-label/boot";
            fsType = "vfat";
          };
        };
      }
    )
  ];
}
