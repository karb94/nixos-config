{
  config.programs.chromium = {
    enable = true;
    extensions = [
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # Bitwarden
      "dcpihecpambacapedldabdbpakmachpb;https://raw.githubusercontent.com/iamadamdev/bypass-paywalls-chrome/master/src/updates/updates.xml"   # Bypass paywalls
    ];
    extraOpts = {
      "show_wallet_icon_on_toolbar" = false;
    };

  };
}
