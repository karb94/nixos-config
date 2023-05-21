# User configuration
{
  # Users and user settings cannot be modified
  users.mutableUsers = false;

  # Deactivate root user
  users.users.root.hashedPassword = "!";

  users.users = {
    carles = {
      passwordFile = "/persist/system/passwords/carles";
      isNormalUser = true;
      extraGroups = [ "wheel" "video" ];
    };
  };
}
