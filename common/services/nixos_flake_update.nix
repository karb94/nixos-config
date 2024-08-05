{ pkgs, ... }:
{
  systemd.services.nixos-flake-update = {
    description = "Update NixOS configuration flake.lock file at /etc/nixos";
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.git ];
    serviceConfig = {
      ExecStart = "${pkgs.nix}/bin/nix flake update -vvv /etc/nixos";
    };
  };
}
