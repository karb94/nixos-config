# Packages to install
{
  pkgs,
  ...
}:
with pkgs; let
  cli_pkgs = [
    # clang           # C/C++ compiler
    bash            # Bash scripting language
    bashInteractive # Bash shell interpreter
    bottom          # Computer resource monitor
    btrfs           # Linux file system
    cmake           # Crossplatform project builder
    complete-alias  # Bash alias completion
    coreutils       # GNU core utils
    cryptsetup      # Tool to manage encrypted devices (LUKS)
    fd              # Better `find` command
    file            # Tool to check the type of a file
    findutils       # GNU `find` and `xargs` commands
    fzf             # Fuzzy finder
    gcc             # C/C++ compiler
    git             # Version control
    gnumake         # `make` command
    gptfdisk        # `gdisk` and `sgdisk` disk management tools
    jq              # JSON parser
    lf              # Terminal file manager
    man-pages       # Man pages
    man-pages-posix # Posix man pages
    newsboat        # Terminal RSS feed manager
    nixos-option    # Inspect the value of nixOS configuration options
    python311       # Python 3.11
    ripgrep         # Better `grep` command
    tree            # Tree representation of a directory
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
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = cli_pkgs ++ neovim_pkgs;
}
