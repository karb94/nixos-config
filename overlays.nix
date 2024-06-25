{pkgs, ...}:
{
  nixpkgs.overlays = [
    (self: super: {
      bluez = pkgs.callPackage ./bluez576.nix {};
    })
  ];
}
