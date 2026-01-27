{
  config,
  pkgs,
  pkgs-unstable,
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
    ".q3a"
    ".inputrc"
    ".logseq"
    ".profile"
    ".profile_extra"
    ".xinitrc"
  ];
  homeSources = mkSymlinks "" homeFilesToSymlink;
  configFilesToSymlink = [
    "FreeTube"
    "alacritty"
    "bash"
    "bspwm"
    "dunst"
    "git"
    "hypr"
    "lf"
    "mpv"
    "newsboat"
    "nvim/after"
    "nvim/compiler"
    "nvim/init.lua"
    "nvim/lua"
    "picom"
    "rofi"
    "sxhkd"
    "wob"
    "youtube-dl"
    "yrp"
    "zathura"
  ];
  configSources = mkSymlinks ".config/" configFilesToSymlink;

  desktopEntries = pkgs.callPackage share/applications/desktopEntries.nix {};

  desktopApps = {
    "brave-browser" = pkgs.brave;
    "dy" = desktopEntries.dy;
    "freetube" = pkgs.freetube;
    "immich" = osConfig.services.immich.desktopItem;
    "Logseq" = pkgs.logseq;
    "org.pwmt.zathura-pdf-mupdf" = pkgs.zathura;
    "pair_hp" = desktopEntries.pair_hp;
    "paperless" = osConfig.services.paperless.desktopItem;
    "reboot" = desktopEntries.reboot;
    "shutdown" = desktopEntries.shutdown;
    "spotify" = pkgs.spotify;
    "suspend" = desktopEntries.suspend;
    "torbrowser" = pkgs.tor-browser;
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
  imports = [ ./zsh.nix ];

  home = {
    stateVersion = "22.11";
    username = primaryUser;
    homeDirectory = "/home/${primaryUser}";
    file = homeSources;
    persistence = lib.mkIf impermanence {
      "/persist" = {
        directories = [
          "projects"
          ".config/dotfiles"
          ".local/share/direnv"
          ".local/share/nvim"
          ".local/share/hyprland"
          ".local/share/zoxide"
          ".local/state/syncthing"
          { directory = ".local/share/containers"; }
          ".config/BraveSoftware/Brave-Browser"
          ".config/Logseq"
          ".config/spotify"
          ".ssh"
          ".tpm2_pkcs11"
        ];
        files = [
          ".local/share/bash/history"
          ".local/share/newsboat/cache.db"
        ];
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
