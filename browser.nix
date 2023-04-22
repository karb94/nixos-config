
{ self, inputs, lib, config, pkgs, ... }: {

  environment.systemPackages = with pkgs; [
    brave
  ];

}
