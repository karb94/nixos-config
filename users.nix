# User configuration
{ ... }: {
  # users.mysql.pam.passwordCrypt = "sha512";
  users.users = {
    carles = {
      initialPassword = "d";
      isNormalUser = true;
      extraGroups = [ "wheel" "video" ];
    };
    # user1 = {
    #   passwordFile = "/nix/persist/passwords/user1";
    #   isNormalUser = true;
    #   extraGroups = [ "video" ];
    # };
  };
}
