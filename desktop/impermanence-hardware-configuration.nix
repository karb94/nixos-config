{ inputs, modulesPath, config, lib, ... }: {

  # Import generic hardware configuration
  imports = [
    inputs.hardware.nixosModules.common-pc
    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-pc-ssd
    inputs.hardware.nixosModules.common-hidpi
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

  fileSystems = {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = [ "size=2G" "mode=755" ];
    };
    "/home" = {
      device = "/dev/disk/by-partlabel/home";
      fsType = "ext4";
    };
    "/nix" = {
      device = "/dev/disk/by-partlabel/nix";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-partlabel/boot";
      fsType = "vfat";
    };
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
  };

  # swapDevices = [
  #   {
  #     device = "/.swapfile";
  #     size = 20480;  # 20GB
  #   }
  # ];

}
