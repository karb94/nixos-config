# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{ inputs, lib, config, pkgs, ... }: {
# You can import other NixOS modules here
  imports = [
    inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
    ./vm-hardware-configuration.nix
  ];

  nixpkgs.config.allowUnfree = true;

  nix = {
# This will add each flake input as a registry
# To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

# This will additionally add your inputs to the system's legacy channels
# Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
# Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
# Deduplicate and optimize nix store
      auto-optimise-store = true;
    };
  };

  environment.systemPackages = with pkgs; [
    brave
    fzf
    git
    lf
    neovim
    tree
  ];

# FIXME: Add the rest of your current configuration

# TODO: Set your hostname
  networking.hostName = "LDN_desktop";
  networking.networkmanager.enable = true;

# TODO: This is just an example, be sure to use whatever bootloader you prefer
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

# https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.11";
}
