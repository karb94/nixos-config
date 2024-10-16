# User configuration
{ config, primaryUser, ... }:
{
  users.users."${primaryUser}" = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "video"
      "syncthing"
    ];
    uid = 1000;
    hashedPasswordFile = "${config.impermanence.systemDir}/passwords/${primaryUser}";
  };
  services.getty.autologinUser = primaryUser;
  users.mutableUsers = false;
}
