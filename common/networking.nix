# Networking
{ hostname, ... }:
{
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.backend = "iwd";
  networking.hostName = hostname;
  networking.nameservers = [
    "194.242.2.5"
    "9.9.9.9"
  ];
  environment.persistence.system.directories =[
    "/etc/NetworkManager/system-connections"
    "/var/lib/NetworkManager"
    "/var/lib/iwd"
  ];

  # Syncthing
  # networking.nat = {
  #   enable = true;
  #   forwardPorts = [
  #     {
  #       sourcePort = 22000;
  #       proto = "tcp";
  #       destination = "88.98.205.86:22000";
  #     }
  #   ];
  # };
}
