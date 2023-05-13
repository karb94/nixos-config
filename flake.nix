# INSTALLATION INSTRUCTIONS
#
# sudo -i
# gdisk /dev/sdX
# n; default; default; +500M; ef00    (EFI system partition)
# n; default; default; default; 8304  (Linux x86-64 root (/))
# w; Y;
# mkfs.fat -F 32 /dev/sdX1 -n boot
# mkfs.ext4 /dev/sdX2 -L root
# mkdir /mnt
# mount /dev/disk/by-label/root /mnt
# mkdir /mnt/boot
# mount /dev/disk/by-label/boot /mnt/boot
# fallocate -l 20G /mnt/.swapfile
# [OR] dd if=/dev/zero of=/mnt/.swapfile bs=1024 count=20971520 (20GB)
# chmod 0600 /mnt/.swapfile
# mkswap /mnt/.swapfile -L swap
# swapon /mnt/.swapfile


{
  description = "NixOS config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

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

  };

  outputs = { self, nixpkgs, home-manager, hardware, ... }@inputs: {
    # NixOS configuration entrypoint
    # Available through:
    # doas nixos-rebuild switch --flake .#your-hostname (locally)
    # doas nixos-rebuild switch --flake github:karb94#selrak (remotely)
    # doas nixos-rebuild switch (if flake is in /etc/nixos)
    # install nixos with:
    # nix-shell -p nixUnstable --run 'sudo nixos-install --no-root-passwd --flake github:karb94/nixos-config#selrak'
    nixosConfigurations = (
      let
        hmConfig = {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.carles = import ./desktop/home.nix;
          home-manager.extraSpecialArgs = { inherit inputs; };
        };
      in
        {
        # FIXME replace with your hostname
        selrak = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; }; # Pass flake inputs to our config
          modules = [
            ./desktop-configuration.nix
            home-manager.nixosModules.home-manager
            hmConfig
            { config._module.args = { inherit self; }; }
          ];
        };

        libvirt_vm = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; }; # Pass flake inputs to our config
          modules = [
            ./configuration.nix
            ./vm-hardware-configuration.nix
            home-manager.nixosModules.home-manager
            hmConfig
            { config._module.args = { inherit self; }; }
          ];
        };

        impermanence = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; }; # Pass flake inputs to our config
            modules = [
              ./desktop-configuration.nix
              ./desktop/impermanence-hardware-configuration.nix
              home-manager.nixosModules.home-manager
              hmConfig
              { config._module.args = { inherit self; }; }
            ];
        };

        live-usb = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./live-usb-configuration.nix ];
        };
      }
    );
  };
}
