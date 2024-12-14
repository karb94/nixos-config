# Yubikeys config
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    age-plugin-yubikey # YubiKey plugin for age
    yubikey-manager # Command line tool for configuring any YubiKey 
    yubioath-flutter # Yubico Authenticator for Desktop
  ];

  # Required for age-plugin-yubikey
  services.pcscd.enable = true;

  # Authenticate super-user using the yubikey
  security.pam.services = {
    login.u2fAuth = true;
    # sudo.u2fAuth = true;
    doas.u2fAuth = true;
  };
  security.pam.u2f = {
    enable = true;
    settings = {
      origin = "pam://yubikey";
      authfile = "/etc/u2f_mappings";
      cue = true;
    };
  };
  environment.persistence.system.files =[
    "/etc/u2f_mappings"
  ];
}
