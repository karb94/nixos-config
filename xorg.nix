# Xorg configuration

{ inputs, lib, config, pkgs, ... }: {

  environment.systemPackages = with pkgs; [
    alacritty
    bspwm
    dunst
    hsetroot
    picom
    rofi
    sxhkd
    unclutter
    xob
    xsel
  ];

  services.xserver.enable = true;
  services.xserver.displayManager.startx.enable = true;
  services.xserver.windowManager.bspwm.enable = true;
  services.xserver.desktopManager.xterm.enable = false;

}
