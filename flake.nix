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
# NixOS configuration entrypoint
# Available through:
# doas nixos-rebuild switch --flake .#your-hostname (locally)
# doas nixos-rebuild switch --flake github:karb94#selrak (remotely)
# doas nixos-rebuild switch (if flake is in /etc/nixos)
# install nixos with:
# nix-shell -p nixUnstable --run 'sudo nixos-install --no-root-passwd --flake github:karb94/nixos-config#selrak'
{
  description = "NixOS config";

  inputs = {
    # Nixpkgs
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small";

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

    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: {
    nixosConfigurations = let
      system = "x86_64-linux";
      primaryUser = "carles";
      # pkgs-rofi174 = import inputs.nixpkgs-rofi174 {
      #   system = system;
      #   config.allowUnfree = true;
      # };
      in {
      selrak = nixpkgs.lib.nixosSystem {
        system = system;
        specialArgs = {
          inherit inputs;
          hostname = "selrak";
          impermanence = false;
          primaryUser = primaryUser;
        }; # Pass flake inputs to our config
        modules = [configurations/desktop.nix];
      };

      brutus = nixpkgs.lib.nixosSystem {
        system = system;
        specialArgs = {
          inherit inputs;
          hostname = "brutus";
          impermanence = true;
          primaryUser = primaryUser;
        };
        modules = [configurations/desktop.nix];
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
