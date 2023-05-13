# General configuration
{ inputs, ... }: {

  imports = [
    ./common/nix.nix
    ./common/bootloader.nix
    ./common/networking.nix
    ./common/audio.nix
    ./common/locale.nix
    ./common/fonts.nix
    ./common/impermanence-users.nix
    ./common/packages.nix
    ./common/doas.nix
    ./desktop/xorg.nix
    ./desktop/impermanence-hardware-configuration.nix
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
