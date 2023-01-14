{ config, pkgs, ... }:
with config;
let
  mkSymlinks = commonDir: 
    let
      ln = lib.file.mkOutOfStoreSymlink;
      f = path: {
        name = "${path}";
        value = {source = ln "${commonDir}/${path}";};
      };
    in
      paths: builtins.listToAttrs (map f paths);

  userName = "/home/carles";
  homeDir = "/home/${userName}";
  HomeFilesToLink = [
    ".bashrc"
    ".profile_extra"
  ];
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
in
  {
    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    home.stateVersion = "22.11";
    home.username = "carles";
    home.homeDirectory = "/home/carles";
    # home.sessionVariables = {
    #   EDITOR = "nvim";
    # };

    xdg.configFile = mkSymlinks "${dotConfigDir}" dotConfigFilesToLink;

    programs.bash.enable = true;
    programs.bash.historyFile = "$HOME/.config/bash/history";
    programs.bash.shellOptions = [];
    programs.bash.initExtra = ''
      # Source extra configuration
      test -f "$HOME/.config/bash/config.bash" && source $_
    '';

  }
