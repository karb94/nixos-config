# General configuration
{ inputs, ... }:
{
  imports = [
    inputs.impermanence.nixosModules.impermanence
    ../common/impermanence.nix
    ../common/audio.nix
    ../common/bootloader.nix
    ../common/containers.nix
    ../common/fonts.nix
    ../common/keyboard.nix
    ../common/locale.nix
    ../common/tpm.nix
    ../common/networking.nix
    ../common/nix.nix
    ../common/packages.nix
    ../common/superuser.nix
    ../common/users.nix
    ../common/hardware-configuration.nix
    ../desktop/packages.nix
    ../desktop/wayland.nix
    ../desktop/xdg.nix
    ../home/home-manager.nix
  ];

  nixpkgs.config.permittedInsecurePackages = [ "electron-27.3.11" ];
  impermanence = {
    enable = true;
    systemDir = "/persist/system";
  };
  # environment.persistence.main.files = [ "/etc/foo" ];
  # nixpkgs.overlays = let
  #   makeShellScript = import ../utils/makeShellScript.nix;
  #   filePath = ../desktop/bin/dy;
  #   dependencies = with pkgs; [gnugrep coreutils dunst yt-dlp mpv jq bspwm libwebp curl file xsel];
  #   in [
  #     (self: super: {dy = pkgs.callPackage makeShellScript {inherit filePath dependencies;};})
  #   ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
