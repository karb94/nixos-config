{
  inputs,
  config,
  primaryUser,
  pkgs-unstable,
  ...
}: {
  imports = [inputs.home-manager.nixosModules.home-manager];
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users."${primaryUser}" = import ./home.nix;
  home-manager.extraSpecialArgs = {
    inherit inputs primaryUser pkgs-unstable;
    impermanence = config.impermanence.enable;
  };
}
