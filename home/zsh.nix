{
  pkgs,
  ...
}:
{
  programs.zsh = {
    enable = true;
    autocd = true;
    defaultKeymap = "emacs";
    dotDir = ".config/zsh";
    enableCompletion = true;
  };
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
}
