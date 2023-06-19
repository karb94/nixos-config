{ pkgs, primaryUser, ... }: {
  # virtualisation.docker = {
  #   enable = true;
  #   rootless = {
  #     enable = true;
  #     setSocketVariable = true;
  #   };
  #   # storageDriver = "ext4";
  # };
  # users.users."${primaryUser}".extraGroups = [ "docker" ];
  # environment.systemPackages = [ pkgs.docker-compose ];

  virtualisation = {
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      # dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      # defaultNetwork.dnsname.enable = true;
      # For Nixos version > 22.11
      defaultNetwork.settings = {
       dns_enabled = true;
      };
    };
  };
  environment.systemPackages = [ pkgs.podman-compose ];

  # Open ports for used apps in your local network
  # https://discourse.nixos.org/t/open-firewall-ports-only-towards-local-network/13037/2
  # Immich
  networking.firewall.extraCommands = ''
    iptables -A nixos-fw -p tcp --source 192.168.1.1/24 --dport 2283 -j nixos-fw-accept
'';
}
