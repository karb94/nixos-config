# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{ inputs, lib, config, pkgs, ... }: {
# You can import other NixOS modules here
  imports = [
    inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    ./users.nix
    ./xorg.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
    ./vm-hardware-configuration.nix
  ];

  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    # Enable flakes and new 'nix' command
    experimental-features = ["nix-command" "flakes"];
    # Deduplicate and optimize nix store
    auto-optimise-store = true;
  };

  environment.systemPackages = with pkgs; [
    brave
    fzf
    git
    lf
    neovim
    tree
    coreutils
    findutils
    gnumake
    cmake
    alacritty
  ];

  # TODO: Set your hostname
  networking.hostName = "LDN_desktop";
  networking.networkmanager.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.11";
}
