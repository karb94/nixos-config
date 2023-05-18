# User configuration
{
  users.mutableUsers = false;
  users.users = {
    # Disable root
    root.hashedPassword = "!";
    carles = {
      passwordFile = "/persist/system/passwords/carles";
      isNormalUser = true;
      extraGroups = [ "wheel" "video" ];
    };
  };
}
