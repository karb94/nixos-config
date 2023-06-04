{
  config,
  pkgs,
  lib,
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
    ".local/bin"
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
    "nvim/after"
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

  desktopApps = {
    brave = "brave-browser";
    freetube = "freetube";
    spotify = "spotify";
    zathura = "org.pwmt.zathura-pdf-mupdf";
  };
  desktopAppsSources = let
    ln = config.lib.file.mkOutOfStoreSymlink;
    f = pkgName: appName: let
      appStorePath = pkgs."${pkgName}";
    in {
      name = "applications/${appName}.desktop";
      value = {source = ln "${appStorePath}/share/applications/${appName}.desktop";};
    };
  in (lib.attrsets.mapAttrs' f desktopApps);
in {
  home.stateVersion = "22.11";
  home.username = "carles";
  home.homeDirectory = "/home/carles";

  home.file = homeSources;
  xdg.enable = true; # track XDG files and directories
  xdg.configFile = configSources;
  xdg.dataFile = desktopAppsSources;


}
