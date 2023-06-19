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
    inputs.hardware.nixosModules.common-hidpi
    inputs.hardware.nixosModules.common-pc
    inputs.hardware.nixosModules.common-pc-ssd
    inputs.impermanence.nixosModules.impermanence
  ];

  config = lib.mkMerge [
    {
      boot.initrd.availableKernelModules = [
        "ahci"
        "xhci_pci"
        "nvme"
        "sd_mod"
        "usbhid"
        "usb_storage"
      ];
      boot.kernelModules = ["kvm-amd"];

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
            options = ["size=6G" "mode=755"];
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
          "/swap" = {
            device = luks_root_device;
            fsType = "btrfs";
            options = ["subvol=swap" "compress=zstd" "noatime"];
            neededForBoot = true;
          };
          "/data/immich" = {
            device = luks_data1_device;
            fsType = "btrfs";
            options = ["subvol=immich" "compress=zstd" "noatime"];
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
            "/etc/nixos"
            "/etc/NetworkManager/system-connections"
            "/var/lib/NetworkManager"
            "/var/lib/iwd"
         ];
          files = [
            "/etc/machine-id"
            {
              file = "/etc/nix/id_rsa";
              parentDirectory = {mode = "u=rwx,g=,o=";};
            }
          ];
        };
        swapDevices = [
          {
            device = "/swap/swapfile";
            size = 20480; # 20GB
          }
        ];
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

        swapDevices = [
          {
            device = "/.swapfile";
            size = 20480; # 20GB
          }
        ];
      }
    )
  ];
}
