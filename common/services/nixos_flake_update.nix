{ pkgs, ... }:
{
  systemd.services.nixos-flake-update = {
    description = "Update NixOS configuration flake.lock file at /etc/nixos";
    # wants = [ "network.target" ];
    # after = [ "network.target" ];
    # wantedBy = [ "multiuser.target" ];
    path = [ pkgs.gitMinimal ];
    serviceConfig = {
      ExecStartPre = "${pkgs.networkmanager}/bin/nm-online";
      ExecStart = "${pkgs.nix}/bin/nix flake update -vvv /etc/nixos";
    };
  };
  systemd.timers.nixos-flake-update = {
    description = "Run nixos-flake-update.service 30 seconds after boot";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "30";
    };
  };
}
