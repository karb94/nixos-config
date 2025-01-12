{ pkgs, ... }:
{
  systemd.services.nixos-flake-update = {
    description = "Update NixOS configuration flake.lock file at /etc/nixos";
    after = [ "network.target" ];
    wantedBy = [ "network.target" ];
    path = [ pkgs.gitMinimal ];
    serviceConfig = {
      type = "oneshot";
      # ExecStart = "${pkgs.coreutils}/bin/true";
      RemainAfterExit = true;
      ExecStop = "${pkgs.nix}/bin/nix flake update -vvv --flake /etc/nixos";
    };
  };
}
