{pkgs-bluez572, ...}:
{
  nixpkgs.overlays = [
    (self: super: {
      bluez = pkgs-bluez572.bluez;
    })
  ];
}
