# Packages to install
{
  pkgs,
  ...
}:
with pkgs; let
  cli_pkgs = [
    bash            # Bash scripting language
    bashInteractive # Bash shell interpreter
    complete-alias  # Bash alias completion
    bottom          # Computer resource monitor
    clang           # C/C++ compiler
    gcc             # C/C++ compiler
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
             # Tool to convert webp image format to png/jpg
    man-pages       # Man pages
    man-pages-posix # Posix man pages
    newsboat        # Terminal RSS feed manager
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
