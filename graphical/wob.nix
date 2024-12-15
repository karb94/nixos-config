# Lightweight overlay bar for Wayland
{ lib, pkgs, ... }:
{
  options = {
    services.wob = {
      enable = lib.mkEnableOption "wob";
      systemDir = lib.mkOption {
        default = "/persist/system";
        type = lib.types.path;
        description = "Persistent files and directories are stored here";
      };
    };
  };

  config = {
    systemd.user.services.wob_volume = {
      description = "A lightweight overlay bar for Wayland";
      documentation = [ "man:wob(1)" ];
      partOf = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];
      unitConfig = {
        ConditionEnvironment = "WAYLAND_DISPLAY";
      };
      serviceConfig = {
        StandardInput = "socket";
        ExecStart = "${pkgs.wob}/bin/wob";
      };
    };

    systemd.user.sockets.wob_volume = {
      wantedBy = [ "sockets.target" ];
      socketConfig = {
        ListenFIFO = "%t/wob_volume.sock";
        SocketMode = "0600";
        RemoveOnStop = "on";
        # If wob exits on invalid input, systemd should NOT shove following input right back into it after it restarts
        FlushPending = "yes";
      };
    };
    environment.systemPackages = let
      wob_volume = pkgs.resholve.writeScriptBin "wob_volume" {
        inputs = [ pkgs.coreutils pkgs.wob pkgs.wireplumber ];
        interpreter = "${pkgs.bash}/bin/bash";
      } (builtins.readFile ./wob_volume);
    in [ pkgs.wob wob_volume ];
  };
}
