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

    # citrix_workspace_2302.url = "tarball+https://downloads.citrix.com/21641/linuxx64-23.2.0.10.tar.gz?__gda__=exp=1684881251~acl=/*~hmac=f37429dfa2fd8cd56f2640cf19ffe2b8e058e79350ec81b6daa4ddbca303e410";
    # citrix_workspace_2302.flake = false;
    # "https://downloads.citrix.com/21641/linuxx64-23.2.0.10.tar.gz?__gda__=exp=1684881251~acl=%2f*~hmac=f37429dfa2fd8cd56f2640cf19ffe2b8e058e79350ec81b6daa4ddbca303e410"
    # "https://downloads.citrix.com/21641/linuxx64-23.2.0.10.tar.gz?__gda__=exp=1684881251~acl=/*~hmac=f37429dfa2fd8cd56f2640cf19ffe2b8e058e79350ec81b6daa4ddbca303e410"
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: {
    nixosConfigurations = {
      # FIXME replace with your hostname
      selrak = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;}; # Pass flake inputs to our config
        modules = [configurations/desktop.nix];
      };

      impermanence = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [configurations/impermanence.nix];
      };

      # Build ISO image with the following command:
      # nix build .#nixosConfigurations.live-usb.config.system.build.isoImage --impure
      # doas dd if=result/iso/id-live.iso of=/dev/sdb bs=4M conv=fsync
      live-usb = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [configurations/live-usb.nix];
      };

      # libvirt_vm = nixpkgs.lib.nixosSystem {
      #   specialArgs = { inherit inputs; }; # Pass flake inputs to our config
      #   modules = [ ./configuration.nix ];
      # };
    };
  };
}
