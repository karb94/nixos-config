# INSTALLATION INSTRUCTIONS
#
# sudo gdisk /dev/sdX
# n; default; default; +500M; ef00    (EFI system partition)
# n; default; default; default; 8304  (Linux x86-64 root (/))
# w; Y;
# sudo mkfs.fat -F 32 /dev/sdX1 -n boot
# sudo mkfs.ext4 /dev/sdX2 -L root
# sudo mkdir /mnt
# sudo mount /dev/disk/by-label/root /mnt
# sudo mkdir /mnt/boot
# sudo mount /dev/disk/by-label/boot /mnt/boot
# sudo dd if=/dev/zero of=/mnt/.swapfile bs=1024 count=10485760 (10GB)


{
  description = "NixOS config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # NixOS hardware configuration
    hardware.url = "github:nixos/nixos-hardware";

    # Dotfiles
    dotfiles.url = "github:karb94/dotfiles/nixos";
    dotfiles.flake = false;

  };

  outputs = { self, nixpkgs, home-manager, hardware, ... }@inputs: {
    # NixOS configuration entrypoint
    # Available through:
    # nixos-rebuild switch --flake .#your-hostname (locally)
    # nixos-rebuild switch --flake github:karb94#LDN_desktop (remotely)
    # install nixos with:
    # nix-shell -p nixUnstable --run 'sudo nixos-install --flake github:karb94/nixos-config#LDN_desktop'
    nixosConfigurations = {
      # FIXME replace with your hostname
      LDN_desktop = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; }; # Pass flake inputs to our config
        # > Our main nixos configuration file <
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.carles = import ./home.nix;
            home-manager.extraSpecialArgs = { inherit inputs; };
          }
          { config._module.args = { inherit self; }; }
        ];
      };
    };

  };
}
