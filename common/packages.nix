# Packages to install
{
  lib,
  pkgs,
  ...
}:
with pkgs; let
  citrix_workspace_2302_src = fetchurl {
    url = "https://downloads.citrix.com/21641/linuxx64-23.2.0.10.tar.gz?__gda__=exp=1685116280~acl=/*~hmac=44a44d5e5f6479108953b43f87dfb9916f75c65439a2414297a2062ee1bff32e";
    name = "linuxx64-23.2.0.10.tar.gz";
    sha256 = "d0030a4782ba4b2628139635a12a7de044a4eb36906ef1eadb05b6ea77c1a7bc";
  };
  citrix_workspace_ovr = citrix_workspace.overrideAttrs (
    oldAttrs: {src = citrix_workspace_2302_src;}
  );
  general_pkgs = [
    alacritty
    brave
    citrix_workspace_ovr
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
    cryptsetup
    fd
    file
    findutils
    fzf
    git
    gnumake
    gptfdisk
    jq
    lf
    libwebp
    man-pages
    man-pages-posix
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
