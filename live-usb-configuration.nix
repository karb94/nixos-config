# General configuration
{
  inputs,
    lib,
    pkgs,
    ...
}: {

  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-base.nix>
  ];

  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    # Enable flakes and new 'nix' command
    experimental-features = ["nix-command" "flakes"];
    # Deduplicate and optimize nix store
    auto-optimise-store = true;
  };

  # Networking
  networking.hostName = "live-usb";
  networking.useDHCP = lib.mkDefault true;
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.backend = "iwd";

  # Locale
  i18n.supportedLocales = [
    "en_GB.UTF-8/UTF-8"
      "es_ES.UTF-8/UTF-8"
      "ca_ES.UTF-8/UTF-8"
  ];
  i18n.defaultLocale = "en_GB.UTF-8";

  isoImage.volumeID = lib.mkForce "id-live";
  isoImage.isoName = lib.mkForce "id-live.iso";

  # security.polkit.extraConfig = ''
  #   polkit.addRule(function(action, subject) {
  #       if (subject.isInGroup("wheel")) {
  #       return polkit.Result.YES;
  #       }
  #       });
  # '';

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
