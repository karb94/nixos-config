{ inputs, lib, config, pkgs, ... }: {

  programs.hyprland = {
    enable = true;
    # xwayland.hidpi = true;
  };
  # programs.hyprland.package = let
  #   system = pkgs.stdenv.hostPlatform.system;
  # in inputs.hyprland.packages.${system}.hyprland;

  environment.systemPackages = with pkgs; [
    # bspwm
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

  services.xserver.enable = true;
  services.xserver.displayManager.startx.enable = true;
  services.xserver.windowManager.bspwm.enable = true;
  services.xserver.desktopManager.xterm.enable = false;

}
