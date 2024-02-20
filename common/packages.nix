# Packages to install
{ pkgs, ... }:
with pkgs;
let
  cli_pkgs = [
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
    lf # Terminal file manager
    man-pages # Man pages
    man-pages-posix # Posix man pages
    ncdu # Disk usage analyzer
    newsboat # Terminal RSS feed manager
    nixos-option # Inspect the value of nixOS configuration options
    openssl # Cryptographic library
    python311 # Python 3.11
    ripgrep # Better `grep` command
    texlive.combined.scheme-full
    tree # Tree representation of a directory
    unzip # Extraction utility for .zip archives
    usbutils # Tools for working with USB devices, such as lsusb
    zellij # Terminal multiplexer
    zoxide # A modern cd
  ];
  neovim_pkgs = [
    neovim # Terminal editor
    # nixfmt # Nix formatter
    nixfmt-rfc-style # NixPkgs official formatter
    nixd # Nix language server
    tree-sitter # Code parser
    nodePackages.bash-language-server # Bash language server
    nodePackages.vim-language-server # Vim language server
    lua-language-server # Lua language server
    nodePackages.pyright # Python language server
  ];
in {
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = cli_pkgs ++ neovim_pkgs;
  programs.neovim = {
    defaultEditor = true;
    withPython3 = true;
  };
}
