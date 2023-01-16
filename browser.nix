{
  config.programs.chromium = {
    enable = true;
    extensions = [
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # Bitwarden
      # { id = "nngceckbapebfimnlniiiahkandclblb"; } # Ublock Origin
      {
        id = "dcpihecpambacapedldabdbpakmachpb";   # Bypass paywalls
        updateUrl = "https://raw.githubusercontent.com/iamadamdev/bypass-paywalls-chrome/master/src/updates/updates.xml";
      }
    ];
    extraOpts = {
      "show_wallet_icon_on_toolbar" = false;
    };

  };
}
