{ pkgs, lib, ... }:
{
  systemd.services.nixos-flake-update = {
    description = "Update NixOS configuration flake.lock file at /etc/nixos";
    after = [ "network.target" ];
    wantedBy = [ "network.target" ];
    path = [ pkgs.gitMinimal ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = lib.concatStrings [
        "${pkgs.nix}/bin/nix"
        "flake update"
        "-vvv"
        "--commit-lock-file"
        "--connect-timeout 10"
        "--stalled-download-timeout 10"
        "--flake /etc/nixos"
      ];
    };
  };
}
