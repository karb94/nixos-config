{
  config,
  pkgs,
  lib,
  inputs,
  impermanence,
  primaryUser,
  ...
}: let
  repoName = "dotfiles";
  sourcesDir = "${config.xdg.configHome}/${repoName}";
  mkSymlinks = commonDir: let
    ln = config.lib.file.mkOutOfStoreSymlink;
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
    # ".local/bin"
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
    "newsboat"
    "newsboat"
    # "nvim/after"
    #"nvim/init.vim"
    #"nvim/lua"
    "picom"
    "rofi"
    "sxhkd"
    "xob"
    "youtube-dl"
    "zathura"
  ];
  configSources = mkSymlinks ".config/" configFilesToSymlink;

  desktopEntries = import share/applications/desktopEntries.nix {inherit pkgs lib;};
  # dy_desktop = pkgs.makeDesktopItem {
  #   name = "dy";
  #   exec = "${shell_scripts.dy}/bin/dy";
  #   icon = share/icons/dy.svg;
  #   desktopName = "dy";
  #   genericName = "Youtube video downloader";
  # };

  desktopApps = with pkgs; {
    "brave-browser" = brave;
    "freetube" = freetube;
    "spotify" = spotify;
    "org.pwmt.zathura-pdf-mupdf" = zathura;
    "dy" = desktopEntries.dy;
    "pair_hp" = desktopEntries.pair_hp;
    "logseq" = logseq;
  };
  desktopAppsSources = let
    ln = config.lib.file.mkOutOfStoreSymlink;
    f = appName: deriv:
    {
      name = "applications/${appName}.desktop";
      value = {source = ln "${deriv}/share/applications/${appName}.desktop";};
    };
  in (lib.attrsets.mapAttrs' f desktopApps);
in {
  imports = [inputs.impermanence.nixosModules.home-manager.impermanence];

  home.persistence = lib.mkIf impermanence {
    "/persist/home/${primaryUser}" = {
      directories = [
        ".config/dotfiles"
        ".local/share/icons"
        ".config/BraveSoftware/Brave-Browser"
        ".ssh"
      ];
      files = [
        ".local/share/bash/history"
        ".local/share/newsboat/cache.db"
      ];
    };
  };

  home.stateVersion = "22.11";
  home.username = primaryUser;
  home.homeDirectory = "/home/${primaryUser}";

  home.file = homeSources;
  xdg.enable = true; # track XDG files and directories
  xdg.configFile =
    configSources
    // {
      nvim = {
        source = ./dotfiles/.config/nvim;
        recursive = true;
      };
    };

  xdg.dataFile = desktopAppsSources;

  
  # xdg.desktopEntries = {
  #   dy = {
  #     name = "dy";
  #     genericName = "Youtube video downloader";
  #     exec = "${shell_scripts.dy}/bin/dy";
  #   };
  # };
}
