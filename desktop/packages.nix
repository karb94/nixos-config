# Packages to install
{
  lib,
  pkgs,
  ...
}:
let
general_pkgs = with pkgs; [
    alacritty              # Terminal emulator
    brave                  # Web browser
    citrix_workspace       # Remote desktop
    flameshot              # Screenshot tool
    freetube               # FOSS youtube front-end
    nsxiv                  # Image viewer
    mpv                    # Video player
    spotify                # Music player
    tor-browser-bundle-bin # Secure and private internet browser
    zathura                # PDF viewer
    networkmanagerapplet
    logseq
  ];

  cli_pkgs = with pkgs; [
    newsboat        # Terminal RSS feed manager
    yt-dlp          # Youtube video downloader
  ];

  shell_scripts = lib.attrValues (import ./shell_scripts.nix {inherit pkgs lib;});

in {

  environment.systemPackages = general_pkgs ++ cli_pkgs ++ shell_scripts;

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
