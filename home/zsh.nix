{
  config,
  ...
}:
{
  programs = {
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
    zsh = {
      enable = true;
      autocd = true;
      defaultKeymap = "emacs";
      dotDir = "${config.xdg.configHome}/zsh";
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      autosuggestion = {
        enable = true;
        strategy = [
          "completion"
          "history"
        ];
      };
      initContent = ''
        bindkey "^[OH" beginning-of-line
        bindkey "^[OF" end-of-line
        bindkey "^[[3~" delete-char
        zsh_dir="${config.xdg.configHome}/zsh/"
        prompt_path="$${zsh_dir}/prompt.sh"
        [ -f $prompt_path ] && . $prompt_path
      '';
    };
  };
}
