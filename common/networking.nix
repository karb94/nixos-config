# Networking
{ lib, ... }: {
  networking.hostName = "selrak";
  networking.useDHCP = lib.mkDefault true;
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.backend = "iwd";
}
