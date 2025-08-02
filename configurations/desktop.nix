# General configuration
{ inputs, ... }:
{
  imports = [
    ../common
    ../graphical/apps
    ../graphical/audio.nix
    ../graphical/wayland.nix
    ../graphical/xdg.nix
    ../graphical/bluetooth.nix
    ../home/home-manager.nix
  ];

  # Logseq currently uses a version of Electron that has reached end-of-life
  # nixpkgs.config.permittedInsecurePackages = [
  #   "electron-27.3.11"
  #   "libxml2-2.13.8"
  # ];

  # Use impermanence
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
