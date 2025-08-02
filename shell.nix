let
  pkgs = import <nixpkgs> { };
  overlay = import ./yt-dlp.nix { } pkgs;
in
pkgs.mkShellNoCC {
  packages = [
    overlay.yt-dlp
  ];
}
