# Fonts
{ pkgs, ... }: {

  console.font = "${pkgs.terminus_font}/share/consolefonts/ter-v16n.psf.gz";

  fonts.fonts = with pkgs; [
    (nerdfonts.override {fonts = ["FiraCode"];})
  ];
}
