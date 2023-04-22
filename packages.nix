# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{ self, inputs, lib, config, pkgs, ... }:
  with pkgs; 
  let
    cli_pkgs = [
      alejandra
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
      neovim
      newsboat
      python311
      ripgrep
      tree
      yt-dlp
    ];
    general_pkgs = [
      alacritty
      brave
      citrix_workspace
      flameshot
      mpv
      spotify
      zathura
    ];
    in
  {

  imports = [
    ./xorg.nix
  ];

  environment.systemPackages = general_pkgs ++ cli_pkgs;

  programs.chromium = {
    enable = true;
    extensions = [
      "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
        "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
        "dbepggeogbaibhgnhhndojpepiihcmeb" # Vimium
        "dcpihecpambacapedldabdbpakmachpb;https://raw.githubusercontent.com/iamadamdev/bypass-paywalls-chrome/master/src/updates/updates.xml"   # Bypass paywalls
    ];
    extraOpts = {
      "show_wallet_icon_on_toolbar" = false;
    };

  };

}
