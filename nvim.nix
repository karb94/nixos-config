
{ self, inputs, lib, config, pkgs, ... }: {

  environment.systemPackages = with pkgs; [
    neovim
    nil
    tree-sitter
    nodePackages.bash-language-server
  ];

}
