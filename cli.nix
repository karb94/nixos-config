
{ self, inputs, lib, config, pkgs, ... }: {

  imports = [ ./nvim.nix ]

  environment.systemPackages = with pkgs; [
    fzf
    git
    lf
    tree
    coreutils
    findutils
    gnumake
    cmake
    newsboat
  ];

}
