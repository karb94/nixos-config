pkgs: with pkgs; rec {
  dy = pkgs.resholve.writeScriptBin "dy" {
    inputs = [
      gnugrep
      coreutils
      dunst
      yt-dlp
      mpv
      jq
      bspwm
      libwebp
      curl
      file
      wl-clipboard
      procps
    ];
    interpreter = "${bash}/bin/bash";
    execer = [
      "cannot:${yt-dlp}/bin/yt-dlp"
      "cannot:${mpv}/bin/mpv"
      "cannot:${procps}/bin/pgrep"
      "cannot:${procps}/bin/pkill"
    ];
  } (builtins.readFile ./dy);
  link_handler = pkgs.resholve.writeScriptBin "link_handler" {
    inputs = [
      dy
      util-linux
      gnused
      curl
      gnused
      nsxiv
      zathura
    ];
    interpreter = "${bash}/bin/bash";
    keep = {
      "$BROWSER" = true;
    };
    execer = [
      "cannot:${dy}/bin/dy"
      "cannot:${nsxiv}/bin/nsxiv"
      "cannot:${util-linux}/bin/setsid" # not true but it's not part of binlore yet
      "cannot:${zathura}/bin/zathura"
    ];
  } (builtins.readFile ./link_handler);
  pair_hp = pkgs.resholve.writeScriptBin "pair_hp" {
    inputs = [
      bluez
      coreutils
      gnugrep
    ];
    interpreter = "${bash}/bin/sh";
  } (builtins.readFile ./pair_hp);
}
