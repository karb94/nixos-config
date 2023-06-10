# Packages to install
{
  lib,
  pkgs,
  ...
}:
let
general_pkgs = with pkgs; [
    alacritty            # Terminal emulator
    brave                # Web browser
    # citrix_workspace     # Remote desktop
    flameshot            # Screenshot tool
    freetube             # FOSS youtube front-end
    nsxiv                # Image viewer
    mpv                  # Video player
    spotify              # Music player
    tor                  # Secure and private internet browser
    zathura              # PDF viewer
    networkmanagerapplet
    logseq
  ];

  cli_pkgs = with pkgs; [
    newsboat        # Terminal RSS feed manager
    yt-dlp          # Youtube video downloader
  ];

  shell_scripts = with pkgs; [
    {name = "dy"; dependencies =  [ yt-dlp mpv jq bspwm libwebp curl file ];}
    {name = "link_handler"; dependencies =  [ curl gnused nsxiv zathura ];}
    {name = "pair_hp"; dependencies =  [ bluez ];}
    {name = "xob_volume"; dependencies =  [ xob wireplumber ];}
  ];
  bin_pkgs = let
    mkShellScript = import ./mkShellScript.nix pkgs;
  in map mkShellScript shell_scripts;

in {

  environment.systemPackages = general_pkgs ++ cli_pkgs ++ bin_pkgs;

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
