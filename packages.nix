# Packages to install
{
  self,
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
with pkgs; let
  general_pkgs = [
    alacritty
    brave
    citrix_workspace
    flameshot
    mpv
    spotify
    zathura
  ];
  cli_pkgs = [
    alejandra
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
    neovim
    nil
    tree-sitter
    nodePackages.bash-language-server
  ];
in {
  imports = [./xorg.nix];

  environment.systemPackages = general_pkgs ++ cli_pkgs ++ neovim_pkgs;

  # Enable doas instead of sudo
  security.doas.enable = true;
  security.sudo.enable = false;
  # Configure doas
  security.doas.extraRules = [
    {
      groups = ["wheel"];
      keepEnv = true;
    }
    {
      groups = ["wheel"];
      cmd = "nixos-rebuild";
      noPass = true;
      keepEnv = true;
    }
    {
      groups = ["wheel"];
      cmd = "nix";
      args = ["store" "gc"];
      noPass = true;
      keepEnv = true;
    }
  ];

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
