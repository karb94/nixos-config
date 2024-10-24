{
  config,
  pkgs,
  lib,
  inputs,
  impermanence,
  primaryUser,
  osConfig,
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
    ".logseq"
  ];
  homeSources = mkSymlinks "" homeFilesToSymlink;
  configFilesToSymlink = [
    "alacritty"
    "bash"
    "bspwm"
    "dunst"
    "git"
    "hypr"
    "lf"
    "mpv"
    "newsboat"
    "picom"
    "rofi"
    "sxhkd"
    "wob"
    "youtube-dl"
    "yrp"
    "zathura"
    "nvim/after"
    "nvim/init.lua"
    "nvim/lua"
    "nvim/compiler"
  ];
  configSources = mkSymlinks ".config/" configFilesToSymlink;

  desktopEntries = pkgs.callPackage share/applications/desktopEntries.nix {};

  desktopApps = {
    "brave-browser" = pkgs.brave;
    "freetube" = pkgs.freetube;
    "spotify" = pkgs.spotify;
    "org.pwmt.zathura-pdf-mupdf" = pkgs.zathura;
    "logseq" = pkgs.logseq;
    "torbrowser" = pkgs.tor-browser;
    "dy" = desktopEntries.dy;
    "pair_hp" = desktopEntries.pair_hp;
    "shutdown" = desktopEntries.shutdown;
    "reboot" = desktopEntries.reboot;
    "suspend" = desktopEntries.suspend;
    "paperless" = osConfig.services.paperless.desktopItem;
  };
  desktopAppsSources = let
    ln = config.lib.file.mkOutOfStoreSymlink;
    f = appName: drv:
    {
      name = "applications/${appName}.desktop";
      value = {source = ln "${drv}/share/applications/${appName}.desktop";};
    };
  in (lib.attrsets.mapAttrs' f desktopApps);
in {
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
  ];

  home = {
    stateVersion = "22.11";
    username = primaryUser;
    homeDirectory = "/home/${primaryUser}";
    file = homeSources;
    persistence = lib.mkIf impermanence {
      "/persist/home/${primaryUser}" = {
        directories = [
          "projects"
          ".config/dotfiles"
          ".local/share/nvim"
          ".local/share/hyprland"
          ".local/share/zoxide"
          ".local/state/syncthing"
          { directory = ".local/share/containers"; method = "symlink"; }
          ".config/BraveSoftware/Brave-Browser"
          ".config/Logseq"
          ".ssh"
        ];
        files = [
          ".local/share/bash/history"
          ".local/share/newsboat/cache.db"
        ];
        allowOther = false;
      };
    };
  };

  xdg = {
    enable = true; # track XDG files and directories
    configFile = configSources;
    dataFile = desktopAppsSources;
  };

  services.syncthing.enable = true;

}
