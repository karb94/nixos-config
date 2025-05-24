# Fonts
{ pkgs, ... }: {

  console = {
    earlySetup = true;
    packages = [pkgs.terminus_font];
    font = "${pkgs.terminus_font}/share/consolefonts/ter-v16n.psf.gz";
  };

  fonts.packages = [
    pkgs.terminus_font
    pkgs.nerd-fonts.fira-code
  ];
}
