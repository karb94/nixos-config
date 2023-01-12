# User configuration
{ inputs, ... }: {
  users.users = {
    carles = {
# If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
# Be sure to change it (using passwd) after rebooting!
      initialPassword = "d";
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };
  };
}
