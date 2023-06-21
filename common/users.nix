# User configuration
{ lib, impermanence, primaryUser, ... }:
{
  config = lib.mkMerge [
    {
      # Deactivate root user
      # users.users.root.hashedPassword = "!";
      users.users."${primaryUser}" = {
        isNormalUser = true;
        extraGroups = [ "wheel" "video" ];
        uid = 1000;
      };
      services.getty.autologinUser = primaryUser;
    }
    (
      lib.mkIf impermanence {
        # Users and user settings cannot be modified
        users.mutableUsers = false;
        users.users."${primaryUser}".passwordFile = "/persist/system/passwords/${primaryUser}";
      }
    )
    (
      lib.mkIf (! impermanence) {
        # Users and user settings can be modified
        users.mutableUsers = true;
        users.users."${primaryUser}".initialPassword = "d";
      }
    )
  ];

}
