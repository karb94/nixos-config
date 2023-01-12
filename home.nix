{ config, pkgs, ... }:
let
  ln = config.lib.file.mkOutOfStoreSymlink;
  dotfiles="${config.xdg.configHome}/dotfiles";
in
  {
    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    home.username = "carles";
    home.homeDirectory = "/home/carles";

    home.stateVersion = "22.11";

    home.file."hm".source = ln ./test_dir/test;
    config.xdg.config = {
      "alacritty".source = ln "${dotfiles}/alacritty";
    };
  }
