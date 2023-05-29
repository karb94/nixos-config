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
    alacritty            # Terminal emulator
    brave                # Web browser
    # citrix_workspace_ovr # Remote desktop
    flameshot            # Screenshot tool
    freetube             # FOSS youtube front-end
    mpv                  # Video player
    spotify              # Music player
    tor                  # Secure and private internet browser
    zathura              # PDF viewer
  ];

  cli_pkgs = [
    bash            # Shell interpreter
    bashInteractive # Shell interpreter
    bitwarden-cli   # Password manager
    bottom          # Computer resource monitor
    clang           # C/C++ compiler
    cmake           # Crossplatform project builder
    coreutils       # GNU core utils
    cryptsetup      # Tool to manage encrypted devices (LUKS)
    fd              # Better `find` command
    file            # Tool to check the type of a file
    findutils       # GNU `find` and `xargs` commands
    fzf             # Fuzzy finder
    git             # Version control
    gnumake         # `make` command
    gptfdisk        # `gdisk` and `sgdisk` disk management tools
    jq              # JSON parser
    lf              # Terminal file manager
    libwebp         # Tool to convert webp image format to png/jpg
    man-pages       # Man pages
    man-pages-posix # Posix man pages
    newsboat        # Terminal RSS feed manager
    python311       # Python 3.11
    ripgrep         # Better `grep` command
    tree            # Tree representation of a directory
    yt-dlp          # Youtube video downloader
  ];

  neovim_pkgs = [
    neovim                            # Terminal editor
    alejandra                         # Nix formatter
    nil                               # Nix language server
    tree-sitter                       # Code parser
    nodePackages.bash-language-server # Bash language server
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
