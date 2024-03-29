# Packages to install
{
  pkgs,
  ...
}:
{
  # CLI to interact with QMK firmware
  environment.systemPackages = [ pkgs.qmk ];

  # Without these udev rules the keyboard cannot be flashed
  services.udev.packages = [
    pkgs.qmk-udev-rules
  ];
  # qmk-udev-rules requires the plugdev group
  users.groups.plugdev = {};

}
