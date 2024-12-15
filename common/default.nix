{ inputs, ... }:
{
  imports = [
    inputs.impermanence.nixosModules.impermanence
    ./bootloader.nix
    ./containers.nix
    ./database.nix
    ./fonts.nix
    ./hardware-configuration.nix
    ./impermanence.nix
    ./keyboard.nix
    ./locale.nix
    ./networking.nix
    ./nix.nix
    ./packages.nix
    ./services/nixos_flake_update.nix
    ./superuser.nix
    ./tpm.nix
    ./users.nix
    ./yubico.nix
  ];
}
