# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{ inputs, lib, config, pkgs, ... }: {
# You can import other NixOS modules here
  imports = [
    inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    ./users.nix
    ./xorg.nix
    ./browser.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
    ./vm-hardware-configuration.nix
  ];

  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    # Enable flakes and new 'nix' command
    experimental-features = ["nix-command" "flakes"];
    # Deduplicate and optimize nix store
    auto-optimise-store = true;
  };

  environment.systemPackages = with pkgs; [
    brave
    fzf
    git
    lf
    neovim
    tree
    coreutils
    findutils
    gnumake
    cmake
    alacritty
    newsboat
  ];

  # TODO: Set your hostname
  networking.hostName = "LDN_desktop";
  networking.networkmanager.enable = true;

  # Enable the OpenSSH server.
  # services.sshd.enable = true;
  # services.openssh.enable = true;
  # services.openssh.permitRootLogin = "yes";
  # networking.firewall.allowedTCPPorts = [ 22 ];
  users.users.carles = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’.
  };
  virtualisation.libvirtd.enable = true;
 
  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Locale
  i18n.supportedLocales = [
    "en_GB.UTF-8/UTF-8"
    "es_ES.UTF-8/UTF-8"
    "ca_ES.UTF-8/UTF-8"
  ];
  i18n.defaultLocale = "en_GB.UTF-8";

  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];


  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.11";
}
