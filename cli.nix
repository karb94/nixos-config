
{ self, inputs, lib, config, pkgs, ... }: {

  imports = [ ./nvim.nix ];

  environment.systemPackages = with pkgs; [
    clang
    cmake
    coreutils
    findutils
    fzf
    git
    gnumake
    lf
    newsboat
    python311
    ripgrep
    tree
  ];

}
