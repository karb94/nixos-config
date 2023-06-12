# General configuration
{ inputs, ... }: {

  imports = [
    ../common/audio.nix
    ../common/bootloader.nix
    ../common/fonts.nix
    ../common/locale.nix
    ../common/networking.nix
    ../common/nix.nix
    ../common/packages.nix
    ../common/superuser.nix
    ../common/users.nix
    ../common/docker.nix
    ../desktop/hardware-configuration.nix
    ../home/home-manager.nix
    ../desktop/packages.nix
    ../desktop/xorg.nix
  ];

  # Home-manager setup script
  environment.etc.link_config = {
    enable = true;
    user = "carles";
    mode = "0700";
    text = ''
      ln -s ${inputs.dotfiles} /home/carles/.config/dotfiles
    '';
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
