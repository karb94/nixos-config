{ config, pkgs, ... }:
with config;
let
  ln = lib.file.mkOutOfStoreSymlink;
  dotfiles="${xdg.configHome}/dotfiles";
  dotconfig = "${dotfiles}/.config";
in
  {
    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    home.username = "carles";
    home.homeDirectory = "/home/carles";

    home.stateVersion = "22.11";

    home.file."hm".source = ln ./test_dir/test;
    xdg.configFile = {
      "alacritty".source = ln "${dotconfig}/alacritty";
    };
  }
