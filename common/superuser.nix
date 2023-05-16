# Superuser configuration
{
  # Enable doas instead of sudo
  security.doas.enable = true;
  security.sudo.enable = false;
  # Configure doas
  security.doas.extraRules = [
    {
      groups = ["wheel"];
      keepEnv = true;
    }
    {
      groups = ["wheel"];
      cmd = "nixos-rebuild";
      noPass = true;
      keepEnv = true;
    }
    {
      groups = ["wheel"];
      cmd = "nix-collect-garbage";
      noPass = true;
      keepEnv = true;
    }
  ];
}
