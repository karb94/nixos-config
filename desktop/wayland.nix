{ pkgs, ... }:
{
  imports = [ ./wob.nix ];

  programs.hyprland = {
    enable = true;
    # package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };

  environment.systemPackages = with pkgs; [
    dunst
    nsxiv
    rofi-wayland
    slurp
    swaybg
    wf-recorder
    wl-clipboard
    xdg-utils
  ];

}
