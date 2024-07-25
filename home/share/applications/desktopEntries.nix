{pkgs, ...}: let
  shell_scripts = import ../../../desktop/scripts pkgs;
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
  shutdown = pkgs.makeDesktopItem {
    name = "shutdown";
    exec = "${pkgs.systemd}/bin/systemctl poweroff";
    icon = ../icons/shutdown.svg;
    desktopName = "Shutdown";
    genericName = "Shutdown PC";
  };
  reboot = pkgs.makeDesktopItem {
    name = "reboot";
    exec = "${pkgs.systemd}/bin/systemctl reboot";
    icon = ../icons/restart.svg;
    desktopName = "Restart";
    genericName = "Reboot PC";
  };
  suspend = pkgs.makeDesktopItem {
    name = "suspend";
    exec = "${pkgs.systemd}/bin/systemctl suspend";
    icon = ../icons/suspend.svg;
    desktopName = "Suspend";
    genericName = "Suspend PC";
  };
}
