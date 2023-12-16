{
  inputs,
  lib,
  pkgs,
  ...
}: {

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };

  environment.systemPackages = with pkgs; [
    dunst
    nsxiv
    rofi-wayland
    slurp
    wf-recorder
    wl-clipboard
    wob
    xdg-utils
  ];

}
