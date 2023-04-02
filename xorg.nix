# Xorg configuration

{ inputs, lib, config, pkgs, ... }: {

  environment.systemPackages = with pkgs; [
    bspwm
    dunst
    hsetroot
    picom
    rofi
    sxhkd
    unclutter
    xob
  ];

  services.xserver.enable = true;
  services.xserver.displayManager.startx.enable = true;
  services.xserver.windowManager.bspwm.enable = true;
  services.xserver.desktopManager.xterm.enable = false;

}
