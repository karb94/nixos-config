# Packages to install
{ lib, pkgs, ... }:
  with pkgs;
  let
    general_pkgs = [
      alacritty
      brave
      # citrix_workspace
      flameshot
      freetube
      mpv
      spotify
      tor
      zathura
    ];

    cli_pkgs = [
      alejandra
      bash
      bashInteractive
      bottom
      clang
      cmake
      coreutils
      fd
      file
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

    neovim_pkgs = [
      nil
      tree-sitter
      nodePackages.bash-language-server
    ];

  in {
    environment.systemPackages = general_pkgs ++ cli_pkgs ++ neovim_pkgs;

    nixpkgs.config.allowUnfree = true;

    programs.chromium = {
      enable = true;
      extensions = [
        "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
        "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
        "dbepggeogbaibhgnhhndojpepiihcmeb" # Vimium
        ( # Bypass paywalls
          lib.strings.concatStrings [
            "dcpihecpambacapedldabdbpakmachpb;"
            "https://raw.githubusercontent.com/"
            "iamadamdev/bypass-paywalls-chrome/"
            "master/src/updates/updates.xml"
          ]
        )
      ];
    };
  }
