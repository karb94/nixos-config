# Packages to install
{
  lib,
  pkgs,
  ...
}:
with pkgs; let
  general_pkgs = [
    alacritty            # Terminal emulator
    brave                # Web browser
    citrix_workspace     # Remote desktop
    flameshot            # Screenshot tool
    freetube             # FOSS youtube front-end
    mpv                  # Video player
    spotify              # Music player
    tor                  # Secure and private internet browser
    zathura              # PDF viewer
  ];

  cli_pkgs = [
    bash            # Bash scripting language
    bashInteractive # Bash shell interpreter
    complete-alias  # Bash alias completion
    bitwarden-cli   # Password manager
    bottom          # Computer resource monitor
    #clang           # C/C++ compiler
    gcc           # C/C++ compiler
    libcxx          # C++ standard library (needed to compile software)
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
    nodePackages.vim-language-server  # Vim language server
    lua-language-server               # Lua language server
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
