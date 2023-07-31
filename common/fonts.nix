# Fonts
{ pkgs, ... }: {

  console = {
    packages = pkgs.terminus_font;
    font = "ter-v16n.psf.gz";
  };

  fonts.packages = [(pkgs.nerdfonts.override {fonts = ["FiraCode"];})];
}
