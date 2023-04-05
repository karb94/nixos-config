{ config, pkgs, ... }:
with config;
let
  repoName = "dotfiles";
  sourcesDir = "${xdg.configHome}/${repoName}";
  mkSymlinks = commonDir: 
    let
      ln = lib.file.mkOutOfStoreSymlink;
      f = path: {
        name = "${path}";
        value = {source = ln "${sourcesDir}/${commonDir}${path}";};
      };
    in
      paths: builtins.listToAttrs (map f paths);
  homeFilesToSymlink = [
    ".bashrc"
    ".inputrc"
    ".profile"
    ".profile_extra"
    ".xinitrc"
  ];
  homeSources = mkSymlinks "" homeFilesToSymlink;
  configFilesToSymlink = [
    "alacritty"
    "bash"
    "bspwm"
    "dunst"
    "git"
    "lf"
    "mpv"
    "newsboat/urls"
    "newsboat/config"
    "nvim/after"
    "nvim/init.vim"
    "nvim/lua"
    "picom"
    "rofi"
    "sxhkd"
    "youtube-dl"
    "zathura"
  ];
  configSources = mkSymlinks ".config/" configFilesToSymlink;
in
  {
    home.stateVersion = "22.11";
    home.username = "carles";
    home.homeDirectory = "/home/carles";

    home.file = homeSources;
    xdg.configFile = configSources;
  }
