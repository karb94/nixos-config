# Packages to install
{
  lib,
  pkgs,
  ...
}:
with pkgs; let
  general_pkgs = [
    alacritty            # Terminal emulator
    brave                # Web browser
    citrix_workspace     # Remote desktop
    flameshot            # Screenshot tool
    freetube             # FOSS youtube front-end
    mpv                  # Video player
    spotify              # Music player
    tor                  # Secure and private internet browser
    zathura              # PDF viewer
  ];

  cli_pkgs = [
    newsboat        # Terminal RSS feed manager
    yt-dlp          # Youtube video downloader
  ];

in {

  environment.systemPackages = general_pkgs ++ cli_pkgs;

  programs.chromium = {
    enable = true;
    extensions = [
      "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
      "dbepggeogbaibhgnhhndojpepiihcmeb" # Vimium
      ( # Bypass paywalls
        lib.strings.concatStrings [
          "dcpihecpambacapedldabdbpakmachpb;"
          "https://raw.githubusercontent.com/"
          "iamadamdev/bypass-paywalls-chrome/"
          "master/src/updates/updates.xml"
        ]
      )
    ];
  };
}
