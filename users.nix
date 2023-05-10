# User configuration
{ inputs, ... }: {
  users.users = {
    carles = {
      initialPassword = "d";
      isNormalUser = true;
      extraGroups = [ "wheel" "video" ];
    };
  };
}
