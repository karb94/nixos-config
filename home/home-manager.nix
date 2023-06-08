{
  inputs,
  impermanence,
  primaryUser,
  ...
}: {
  imports = [inputs.home-manager.nixosModules.home-manager];
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users."${primaryUser}" = import ./home.nix;
  home-manager.extraSpecialArgs = { inherit inputs impermanence primaryUser; };
}
