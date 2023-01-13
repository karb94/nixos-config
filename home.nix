{ config, pkgs, ... }:
with config;
let
  dotfiles="${xdg.configHome}/dotfiles";
  dotConfigDir = "${dotfiles}/.config";
  dotConfigFilesToLink = [
    "alacritty"
    "bash"
    "bspwm"
    "dunst"
    "git"
    "lf"
    "mpv"
    "newsboat"
    "nvim/after"
    "nvim/init.vim"
    "nvim/lua"
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

    xdg.configFile = mkSymlinks "${dotConfigDir}" dotConfigFilesToLink;
  }
