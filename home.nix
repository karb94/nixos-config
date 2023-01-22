{ config, pkgs, ... }:
with config;
let
  repoDir="${xdg.configHome}/dotfiles";
  mkSymlinks = commonDir: 
    let
      ln = lib.file.mkOutOfStoreSymlink;
      f = path: {
        name = "${path}";
        value = {source = ln "${repoDir}/${commonDir}${path}";};
      };
    in
      paths: builtins.listToAttrs (map f paths);

  HomeFilesToLink = [
    ".bashrc"
    ".inputrc"
    ".profile"
    ".profile_extra"
    ".xinitrc"
  ];
  dotConfigFilesToLink = [
    ''BraveSoftware/Brave-Browser/Default/Preferences''
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
    "sxhkd"
    "youtube-dl"
    "zathura"
  ];
in
  {
    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    home.stateVersion = "22.11";
    home.username = "carles";
    home.homeDirectory = "/home/carles";

    home.file = mkSymlinks "" HomeFilesToLink;

    xdg.configFile = mkSymlinks ".config/" dotConfigFilesToLink;
  }
