# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{ self, inputs, lib, config, pkgs, ... }:
  with pkgs; 
  let
    cli_pkgs = [
      bottom
      clang
      cmake
      coreutils
      fd
      findutils
      fzf
      git
      gnumake
      jq
      lf
      libwebp
      newsboat
      python311
      ripgrep
      tree
      yt-dlp
    ];
    general_pkgs = with pkgs; [
      alacritty
      citrix_workspace
      flameshot
      mpv
      spotify
      zathura
    ];
    in
  {

  imports = [
    ./browser.nix
    # ./cli.nix
    ./xorg.nix
  ];

  environment.systemPackages = general_pkgs ++ cli_pkgs;

  # environment.systemPackages = with pkgs; [
  #   alacritty
  #   citrix_workspace
  #   flameshot
  #   mpv
  #   spotify
  #   zathura
  # ];

}
