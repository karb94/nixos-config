# User configuration
{
  users.mutableUsers = false;
  users.users = {
    # Disable root
    root.passwordFile = "/persist/system/passwords/root";
    carles = {
      passwordFile = "/persist/system/passwords/carles";
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      uid = 1000;
    };
  };
}
