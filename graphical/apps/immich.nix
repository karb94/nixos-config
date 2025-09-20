# Immich
{
  lib,
  pkgs,
  pkgs-unstable,
  primaryUser,
  ...
}:
{
  options = {
    services.immich.desktopItem = lib.mkOption {
      # type = lib.types.desktopItem;
      description = "Desktop entry to launch the immich service";
    };
  };

  config = {
    services.immich = {
      enable = true;
      package = pkgs-unstable.immich;
      host = "0.0.0.0";
      secretsFile = "/persist/system/secrets/apps/immich/secretsFile";
      mediaLocation = "/data/media/immich";
    };
    users.users."${primaryUser}".extraGroups = [ "immich" ];

    # Open ports for used apps in your local network
    # https://discourse.nixos.org/t/open-firewall-ports-only-towards-local-network/13037/2
    # The --source is the LAN block address
    # so anything of the form 192.168.1.X/24 will do
    networking.firewall.extraCommands = ''
      iptables -A nixos-fw -p tcp --source 192.168.1.0/24 --dport 2283 -j nixos-fw-accept
    '';

    # Do not start the services on startup
    systemd.services.redis-immich.wantedBy = lib.mkForce [ ];
    systemd.services.immich-machine-learning.wantedBy = lib.mkForce [ ];
    # Start all required services by starting the immich-server service
    systemd.services.immich-server = {
      wantedBy = lib.mkForce [ ];
      wants = lib.mkForce [ ];
      requires = lib.mkForce [
        "immich-machine-learning.service"
        "redis-immich.service"
      ];
    };

    # Allow users in the immich group to start the service
    security.polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
        if (action.id == "org.freedesktop.systemd1.manage-units"
        && subject.isInGroup("immich")) {
          if (action.lookup("unit") == "immich-server.service") {
            var verb = action.lookup("verb");
            if (verb == "start" || verb == "stop" || verb == "restart") {
              return polkit.Result.YES;
            }
          }
        }
      });
    '';

    # Create a desktop entry to launch the service
    services.immich.desktopItem = pkgs.makeDesktopItem {
      name = "immich";
      exec = "${pkgs.systemd}/bin/systemctl start immich-server.service";
      icon = ./immich.svg;
      desktopName = "Immich";
      genericName = "Launch Immich";
    };
  };
}
