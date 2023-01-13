{ config, pkgs, ... }:
with config;
let
  dotfiles="${xdg.configHome}/dotfiles";
  dotConfigDir = "${dotfiles}/.config";
  dotConfigToLink = [
    "alacritty"
    "bash"
    "bspwm"
    "dunst"
    "git"
    "lf"
    "mpv"
    "newsboat"
    "picom"
    "rofi"
    "rofi"
    "sxhkd"
    "youtube-dl"
    "zathura"
  ];
  mkSymlinks = commonDir: 
    let
      ln = lib.file.mkOutOfStoreSymlink;
      f = path: {
        name = "${path}";
        value = {source = ln "${commonDir}/${path}";};
      };
    in
      paths: builtins.listToAttrs (map f paths);
in
  {
    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    home.username = "carles";
    home.homeDirectory = "/home/carles";

    home.stateVersion = "22.11";

    
    # home.file."hm".source = ln ./test_dir/test;
    xdg.configFile = mkSymlink "${dotconfig}" p;
    # xdg.configFile = {
    #   "alacritty/alacritty.yml".source = ln "${dotconfig}/alacritty/alacritty.yml";
    #   "bspwm/bspwmrc".source = ln "${dotconfig}/bspwm/bspwmrc";
    # };
  }
