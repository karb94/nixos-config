# Nix configuration
{
  nix.settings = {
    # Enable flakes and new 'nix' command
    extra-experimental-features = [ "nix-command" "flakes" ];
    # Deduplicate and optimize nix store
    # auto-optimise-store = true;
    # Conform to the XDG Base Directory Specification
    # use-xdg-base-directories = true;
  };
}
