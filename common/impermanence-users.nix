# User configuration
{ ... }: {
  users.mutableUsers = false;
  users.users = {
    carles = {
      passwordFile = "/nix/persist/passwords/carles";
      isNormalUser = true;
      extraGroups = [ "wheel" "video" ];
    };
  };
}
