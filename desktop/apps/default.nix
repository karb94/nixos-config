# Packages to install
{
  lib,
  pkgs,
  pkgs-stable,
  ...
}:
let
  generalPkgs = with pkgs; [
    alacritty # Terminal emulator
    brave # Web browser
    pkgs-stable.citrix_workspace # Remote desktop
    freetube # FOSS youtube front-end
    ledger-live-desktop # Crypto wallet
    pkgs-stable.logseq # Note taking app
    mpv # Video player
    nsxiv # Image viewer
    okular
    spotify # Music player
    tor-browser-bundle-bin # Secure and private internet browser
    zathura # PDF viewer
  ];
  shellScripts = lib.attrValues (import ../scripts pkgs);
in
{
  environment.systemPackages = generalPkgs ++ shellScripts;

  programs.chromium = {
    enable = true;
    extensions = [
      "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
      "dbepggeogbaibhgnhhndojpepiihcmeb" # Vimium
      (
        # Bypass paywalls
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
