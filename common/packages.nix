# Packages to install
{ pkgs, ... }:
let
  cli_pkgs = with pkgs; [
    # clang # C/C++ compiler
    # gh              # GitHub CLI
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
    eza # A modern ls replacement
    fd # Better `find` command
    file # Tool to check the type of a file
    findutils # GNU `find` and `xargs` commands
    fzf # Fuzzy finder
    gcc # C/C++ compiler
    git # Version control
    gnumake # `make` command
    gptfdisk # `gdisk` and `sgdisk` disk management tools
    jq # JSON parser
    just # Command runner
    lf # Terminal file manager
    man-pages # Man pages
    man-pages-posix # Posix man pages
    ncdu # Disk usage analyzer
    newsboat # Terminal RSS feed manager
    nixos-option # Inspect the value of nixOS configuration options
    openssl # Cryptographic library
    pandoc # Conversion between documentation formats
    libreoffice-fresh # Office suite
    python311 # Python 3.11
    ripgrep # Better `grep` command
    lm_sensors # Tools for reading hardware sensors
    texlive.combined.scheme-full
    tree # Tree representation of a directory
    unzip # Extraction utility for .zip archives
    usbutils # Tools for working with USB devices, such as lsusb
    zellij # Terminal multiplexer
    zoxide # A modern cd
  ];
  neovim_pkgs = with pkgs; [
    # nixfmt # Nix formatter
    lua-language-server # Lua language server
    neovim # Terminal editor
    nixd # Nix language server
    nixfmt-rfc-style # NixPkgs official formatter
    nodePackages.bash-language-server # Bash language server
    nodePackages.pyright # Python language server
    nodePackages.vim-language-server # Vim language server
    stylua # An opinionated Lua code formatter
    tree-sitter # Code parser
  ];
in
{
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = cli_pkgs ++ neovim_pkgs;
  programs.neovim = {
    defaultEditor = true;
    withPython3 = true;
  };
}
