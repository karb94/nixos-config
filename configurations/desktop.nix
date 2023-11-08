# General configuration
{ inputs, ... }: {

  imports = [
    ../common/audio.nix
    ../common/bootloader.nix
    ../common/containers.nix
    ../common/fonts.nix
    ../common/keyboard.nix
    ../common/locale.nix
    ../common/networking.nix
    ../common/nix.nix
    ../common/packages.nix
    ../common/superuser.nix
    ../common/users.nix
    ../desktop/hardware-configuration.nix
    ../desktop/packages.nix
    ../desktop/wayland.nix
    ../desktop/xdg.nix
    # ../desktop/xorg.nix
    ../home/home-manager.nix
  ];

  # # Home-manager setup script
  # environment.etc.link_config = {
  #   enable = true;
  #   user = "carles";
  #   mode = "0700";
  #   text = ''
  #     ln -s ${inputs.dotfiles} /home/carles/.config/dotfiles
  #   '';
  # };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
