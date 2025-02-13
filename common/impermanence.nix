{
  lib,
  config,
  ...
}:
let
  cfg = config.impermanence;
in
{
  options = {
    impermanence = {
      enable = lib.mkEnableOption "impermanence";
      systemDir = lib.mkOption {
        default = "/persist/system";
        type = lib.types.path;
        description = "Persistent files and directories are stored here";
      };
    };
  };

  config = {
    environment.persistence.system = {
      enable = cfg.enable;
      persistentStoragePath = cfg.systemDir;
      hideMounts = true;
      # Bare minimum state that NixOS requires based on the NixOS manual
      # https://nixos.org/manual/nixos/unstable/#sec-nixos-state
      directories = [
        "/var/lib/nixos"
        "/var/lib/systemd"
        "/var/log/journal"
        "/etc/nixos"
        "/tmp"  # Uncomment for big rebuilds to avoid running out of space
      ];
      files = [ "/etc/machine-id" ];
    };
  };
}
