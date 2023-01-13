{ config, pkgs, ... }:
with config;
let
  ln = lib.file.mkOutOfStoreSymlink;
  dotfiles="${xdg.configHome}/dotfiles";
  dotconfig = "${dotfiles}/.config";
  # link = parentFolder: path: 
  p = [
    "alacritty/alacritty.yml"
    "bspwm/bspwmrc"
  ];
  # f = commonDir: path: {name="${path}"; value={source=("${commonDir}/${path}");};}
  mkSymlink = commonDir: 
  let
    f = path: {name="${path}"; value={source=("${commonDir}/${path}");};};
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
