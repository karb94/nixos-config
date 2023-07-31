# Fonts
{ pkgs, ... }: {

  console = {
    packages = [pkgs.terminus_font];
    font = "${pkgs.terminus_font}/share/consolefonts/ter-v16n.psf.gz";
  };

  fonts.packages = with pkgs; [
    (nerdfonts.override {fonts = ["FiraCode"];})
  ];
}
