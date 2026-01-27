{
  description = "NixOS config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs-unstable-small.url = "github:nixos/nixpkgs/nixos-unstable-small";
    # nixpkgs-paperless-ngx-2171.url = 
    #   "github:nixos/nixpkgs/5a983011e0f4b3b286aaa73e011ce32b1449a528";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-25.11";
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

  outputs = { nixpkgs, ... } @ inputs: {
    nixosConfigurations = let
      system = "x86_64-linux";
      primaryUser = "carles";
      pkgs-unstable = import inputs.nixpkgs-unstable {
        system = system;
        config.allowUnfree = true;
        config.permittedInsecurePackages = [
          # Citrix dependencies
          "libxml2-2.13.8"
          "libsoup-2.74.3"
        ];
      };
      # pkgs-unstable-small = import inputs.nixpkgs-unstable-small {
      #   system = system;
      #   config.allowUnfree = true;
      # };
      pkgs-paperless = import inputs.nixpkgs-paperless-ngx-2171 {
        system = system;
        config.allowUnfree = true;
      };
    in {
      brutus = nixpkgs.lib.nixosSystem {
        system = system;
        specialArgs = {
          inherit inputs pkgs-unstable pkgs-paperless; # pkgs-unstable-small;
          hostname = "brutus";
          impermanence = true;
          primaryUser = primaryUser;
        };
        modules = [configurations/desktop.nix ./overlays.nix];
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
