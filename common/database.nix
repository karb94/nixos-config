{ pkgs, config, ... }:
{
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16_jit;
    enableJIT = true;
  };
  environment.persistence.system.directories = [config.services.postgresql.dataDir];
}
