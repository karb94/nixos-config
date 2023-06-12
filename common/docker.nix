{ pkgs, ... }: {
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
    storageDriver = "btrfs";
  };
  environment.systemPackages = [ pkgs.docker-compose ];
}
