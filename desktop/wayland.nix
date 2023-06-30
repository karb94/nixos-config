{ inputs, lib, config, pkgs, ... }: {

  programs.hyprland.enable = true;
  #   # xwayland.hidpi = true;
  # };
  # programs.hyprland.package = let
  #   system = pkgs.stdenv.hostPlatform.system;
  # in inputs.hyprland.packages.${system}.hyprland;

  environment.systemPackages = with pkgs; [
    # bspwm
    # hyprland
    dunst
    # hsetroot
    # nsxiv
    # picom
    rofi
    # sxhkd
    # unclutter
    wob
    # xsel
  ];

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

}
