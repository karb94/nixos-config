{
  description = "NixOS config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    # nixpkgs-bluez572.url = "github:nixos/nixpkgs/e89cf1c932006531f454de7d652163a9a5c86668";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Impermanence
    impermanence.url = "github:nix-community/impermanence";

    # NixOS hardware configuration
    hardware.url = "github:nixos/nixos-hardware";

    # Dotfiles
    dotfiles.url = "github:karb94/dotfiles/nixos";
    dotfiles.flake = false;

    # hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: {
    nixosConfigurations = let
      system = "x86_64-linux";
      primaryUser = "carles";
      pkgs-stable = import inputs.nixpkgs-stable {
        system = system;
        config.allowUnfree = true;
        config.permittedInsecurePackages = [ "electron-27.3.11" ];
      };
      # pkgs-bluez572 = import inputs.nixpkgs-bluez572 {
      #   system = system;
      #   config.allowUnfree = true;
      # };
    in {
      brutus = nixpkgs.lib.nixosSystem {
        system = system;
        specialArgs = {
          inherit inputs pkgs-stable; # pkgs-bluez572;
          hostname = "brutus";
          impermanence = true;
          primaryUser = primaryUser;
        };
        modules = [configurations/desktop.nix]; #./overlays.nix];
      };

      # Build ISO image with the following command:
      # nix build .#nixosConfigurations.live-usb.config.system.build.isoImage --impure
      # doas dd if=result/iso/id-live.iso of=/dev/sdb bs=4M conv=fsync
      live-usb = nixpkgs.lib.nixosSystem {
        system = system;
        modules = [configurations/live-usb.nix];
      };

      # libvirt_vm = nixpkgs.lib.nixosSystem {
      #   specialArgs = { inherit inputs; }; # Pass flake inputs to our config
      #   modules = [ ./configuration.nix ];
      # };
    };
  };
}
