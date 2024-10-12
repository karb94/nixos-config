{ pkgs, config, ... }:
{
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16_jit;
    enableJIT = true;
  };
  systemd.tmpfiles.rules = [
    "d ${config.services.postgresql.dataDir} 0750 postgres postgres"
  ];
}
