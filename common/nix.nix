# Nix configuration
{ inputs, ... }:
{
  nix.settings = {
    # Enable flakes and new 'nix' command
    extra-experimental-features = [ "nix-command" "flakes" ];

    # Deduplicate and optimize nix store
    # auto-optimise-store = true;
    # Conform to the XDG Base Directory Specification
    use-xdg-base-directories = true;

    # Use the nix-community Cachix cache server for non-free packages
    substituters = [
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      # Compare to the key published at https://nix-community.org/cache
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
  nix.extraOptions = ''
    bash-prompt-prefix = \n[nix develop]
  '';

  # Use the system's nixpkgs when using nix commands. E.g., nix run nixpkgs#hello
  nix.registry.nixpkgs.flake = inputs.nixpkgs;
}
