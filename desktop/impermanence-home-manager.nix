{ inputs, ... }: {
  imports = [ inputs.home-manager.nixosModules.home-manager ];
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.carles = import ./impermanence-home.nix;
  # Pass extra arguments to ./home.nix
  # home-manager.extraSpecialArgs = { inherit inputs; };
}
