# User configuration
{
  users.mutableUsers = false;
  users.users = {
    # Disable root
    root.hashedPassword = "!";
    carles = {
      passwordFile = "/nix/persist/passwords/carles";
      isNormalUser = true;
      extraGroups = [ "wheel" "video" ];
    };
  };
}
