# General configuration
{
  self,
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./users.nix
    ./packages.nix
    ./hardware-configuration.nix
  ];

  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    # Enable flakes and new 'nix' command
    experimental-features = ["nix-command" "flakes"];
    # Deduplicate and optimize nix store
    auto-optimise-store = true;
  };

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = "selrak";
  networking.useDHCP = lib.mkDefault true;
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.backend = "iwd";

  # Audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  hardware.bluetooth.enable = true;

  # Locale
  i18n.supportedLocales = [
    "en_GB.UTF-8/UTF-8"
    "es_ES.UTF-8/UTF-8"
    "ca_ES.UTF-8/UTF-8"
  ];
  i18n.defaultLocale = "en_GB.UTF-8";

  # Fonts
  fonts.fonts = with pkgs; [
    (nerdfonts.override {fonts = ["FiraCode"];})
  ];

  # Setup script
  environment.etc.link_config = {
    enable = true;
    user = "carles";
    mode = "0700";
    text = ''
      ln -s ${inputs.dotfiles} /home/carles/.config/dotfiles
    '';
  };

  # Auto-update flake
  # system.autoUpgrade = {
  #   enable = true;
  #   allowReboot = false;
  #   flake = self.outPath;
  #   flags = [
  #     "--recreate-lock-file"
  #     "--no-write-lock-file"
  #     "-L"
  #   ];
  #   dates = "daily";
  # };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
