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
  };
  # Use the system's nixpkgs when using nix commands. E.g., nix run nixpkgs#hello
  nix.registry.nixpkgs.flake = inputs.nixpkgs;
}
