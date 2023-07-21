{pkgs, lib}: let
  shell_scripts = import ../../../desktop/shell_scripts.nix {inherit pkgs lib;};
in {
  dy = pkgs.makeDesktopItem {
    name = "dy";
    exec = "${shell_scripts.dy}/bin/dy";
    icon = ../icons/dy.svg;
    desktopName = "dy";
    genericName = "Youtube video downloader";
  };
  pair_hp = pkgs.makeDesktopItem {
    name = "pair_hp";
    exec = "${shell_scripts.pair_hp}/bin/pair_hp";
    icon = ../icons/pair_hp.svg;
    desktopName = "Pair headphones";
    genericName = "Sony WH-1000XM5";
  };
}
