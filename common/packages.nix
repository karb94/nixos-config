# Packages to install
{ pkgs, pkgs-unstable, ... }:
let
  cli_pkgs = with pkgs; [
    # clang # C/C++ compiler
    gh # GitHub CLI
    age
    age-plugin-tpm
    bash # Bash scripting language
    bashInteractive # Bash shell interpreter
    bat # cat clone with syntax highlighting and Git integration
    bottom # Computer resource monitor
    btrfs-progs # Linux file system
    cmake # Crossplatform project builder
    complete-alias # Bash alias completion
    coreutils # GNU core utils
    cryptsetup # Tool to manage encrypted devices (LUKS)
    delta # Diff tool
    evemu # Control your mouse programatically
    expect # Tool for automating interactive applications
    eza # A modern ls replacement
    fd # Better `find` command
    file # Tool to check the type of a file
    findutils # GNU `find` and `xargs` commands
    fzf # Fuzzy finder
    gcc # C/C++ compiler
    git # Version control
    git-lfs # Version control for large files
    glibc
    gnumake # `make` command
    gptfdisk # `gdisk` and `sgdisk` disk management tools
    jq # JSON parser
    just # Command runner
    lf # Terminal file manager
    # libreoffice-fresh # Office suite
    lm_sensors # Tools for reading hardware sensors
    man-pages # Man pages
    man-pages-posix # Posix man pages
    ncdu # Disk usage analyzer
    newsboat # Terminal RSS feed manager
    nh # Nix CLI helper
    nix-index # Files database for nixpkgs
    nixos-option # Inspect the value of nixOS configuration options
    nix-output-monitor # Prettifies output of Nix commands
    nushell # A modern shell written in Rust
    oath-toolkit # One-time password authentication tool
    openssl # Cryptographic library
    pandoc # Conversion between documentation formats
    python311 # Python 3.11
    ripgrep # Better `grep` command
    syncthing # Continuous file synchronization
    # texlive.combined.scheme-full # Latex suite
    tree # Tree representation of a directory
    unzip # Extraction utility for .zip archives
    usbutils # Tools for working with USB devices, such as lsusb
    uv # Python package resolver and installer
    yt-dlp # Youtube video downloader
    # zellij # Terminal multiplexer
    zoxide # A modern cd
  ];
  neovim_pkgs = with pkgs-unstable; [
    # nixfmt # Nix formatter
    lua-language-server # Lua language server
    neovim # Terminal editor
    nixd # Nix language server
    nixfmt-rfc-style # NixPkgs official formatter
    bash-language-server # Bash language server
    ruff # Python linter
    isort # Python imports formatter
    basedpyright # Python language server
    vim-language-server # Vim language server
    stylua # An opinionated Lua code formatter
    tree-sitter # Code parser
  ];
in
{
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = cli_pkgs ++ neovim_pkgs;
  programs = {
    direnv.enable = true;
    neovim = {
      defaultEditor = true;
      withPython3 = true;
    };
    git = {
      enable = true;
      config = {
        safe.directory = "/etc/nixos";
      };
    };
    zsh = {
      enable = true;
      syntaxHighlighting = {
        enable = true;
      };
      autosuggestions = {
        enable = true;
      };
    };
  };
}
