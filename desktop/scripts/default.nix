pkgs:
let makeShellScript = pkgs.callPackage (import ../../utils/makeShellScript.nix);
in with pkgs; rec {
  dy = pkgs.resholve.writeScriptBin "dy" {
    inputs = [ gnugrep coreutils dunst yt-dlp mpv jq bspwm libwebp curl file wl-clipboard procps ];
    interpreter = "${bash}/bin/bash";
    execer = [
      "cannot:${yt-dlp}/bin/yt-dlp"
      "cannot:${mpv}/bin/mpv"
      "cannot:${procps}/bin/pgrep"
      "cannot:${procps}/bin/pkill"
    ];
  } (builtins.readFile ./dy);
  link_handler = pkgs.resholve.writeScriptBin "link_handler" {
    inputs = [ dy util-linux gnused curl gnused nsxiv zathura ];
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
    inputs = [ bluez ];
    interpreter = "${bash}/bin/sh";
  } (builtins.readFile ./pair_hp);
  wob_volume = pkgs.resholve.writeScriptBin "wob_volume" {
    inputs = [ coreutils wob wireplumber ];
    interpreter = "${bash}/bin/bash";
  } (builtins.readFile ./wob_volume);
  # dy = makeShellScript {
  #   filePath = ./dy;
  #   dependencies =
  #     [ gnugrep coreutils dunst yt-dlp mpv jq bspwm libwebp curl file xsel ];
  # };
  # link_handler = makeShellScript {
  #   filePath = ./link_handler;
  #   dependencies = [ dy util-linux gnused curl gnused nsxiv zathura ];
  # };
  # pair_hp = makeShellScript {
  #   filePath = ./pair_hp;
  #   dependencies = [ bluez ];
  # };
  # wob_volume = makeShellScript {
  #   filePath = ./wob_volume;
  #   dependencies = [ coreutils wob wireplumber ];
  # };
}
