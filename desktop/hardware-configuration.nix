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
      device = "/dev/disk/by-label/root";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };
  };

  swapDevices = [
    {
      device = "/.swapfile";
      size = 20480;  # 20GB
    }
  ];

}
