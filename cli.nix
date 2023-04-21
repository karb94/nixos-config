
{ self, inputs, lib, config, pkgs, ... }: {

  imports = [ ./nvim.nix ];

  environment.systemPackages = with pkgs; [
    bottom
    clang
    cmake
    coreutils
    fd
    findutils
    fzf
    git
    gnumake
    jq
    lf
    libwebp
    newsboat
    python311
    ripgrep
    tree
    yt-dlp
  ];

}
