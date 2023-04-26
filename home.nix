{
  config,
  pkgs,
  ...
}:
with config; let
  repoName = "dotfiles";
  sourcesDir = "${xdg.configHome}/${repoName}";
  mkSymlinks = commonDir: let
    ln = lib.file.mkOutOfStoreSymlink;
    f = path: {
      name = "${path}";
      value = {source = ln "${sourcesDir}/${commonDir}${path}";};
    };
  in paths: builtins.listToAttrs (map f paths);

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
    "nvim/init.vim"
    "nvim/lua"
    "picom"
    "rofi"
    "sxhkd"
    "xob"
    "youtube-dl"
    "zathura"
  ];
  configSources = mkSymlinks ".config/" configFilesToSymlink;

  linkDesktopApps = let
    ln = lib.file.mkOutOfStoreSymlink;
    appStorePath = pkgs."${appName}";
    f = pkgName: appName: {
      name = "applications/${appName}.desktop";
      value = {source = ln "${appStorePath}/share/applications/${appName}.desktop";};
    };
    in paths: builtins.listToAttrs (lib.attrsets.mapAttrs' f);
  desktopApps = {
    zathura = "org.pwmt.zathura-pdf-mupdf";
    brave = "brave-browser";
    spotify = "spotify";
  };
  # desktopAppsSources = linkDesktopApps desktopApps;
  # f = pkgName: appName: {
  #   name = "applications/${appName}.desktop";
  #   value = {source = ln "${appStorePath}/share/applications/${appName}.desktop";};
  # };
  # desktopApps;

in {
  home.stateVersion = "22.11";
  home.username = "carles";
  home.homeDirectory = "/home/carles";

  home.file = homeSources;
  xdg.enable = true; # track XDG files and directories
  xdg.configFile = configSources;

  # xdg.dataFile = desktopAppsSources;

  xdg.dataFile = {
    "applications/brave-browser.desktop".source = lib.file.mkOutOfStoreSymlink "${pkgs.brave}/share/applications/brave-browser.desktop";
    "applications/spotify.desktop".source = lib.file.mkOutOfStoreSymlink "${pkgs.spotify}/share/applications/spotify.desktop";
    "applications/org.pwmt.zathura-pdf-mupdf.desktop".source = lib.file.mkOutOfStoreSymlink "${pkgs.zathura}/share/applications/.desktop";
  };
}
