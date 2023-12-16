pkgs:
let
  makeShellScript = pkgs.callPackage (import ../../utils/makeShellScript.nix);
in
with pkgs; rec {
  dy = makeShellScript {
    filePath = ./dy;
    dependencies = [ gnugrep coreutils dunst yt-dlp mpv jq bspwm libwebp curl file xsel ];
  };
  link_handler = makeShellScript {
    filePath = ./link_handler;
    dependencies = [ dy util-linux gnused curl gnused nsxiv zathura ];
  };
  pair_hp = makeShellScript {
    filePath = ./pair_hp;
    dependencies = [ bluez ];
  };
  wob_volume = makeShellScript {
    filePath = ./wob_volume;
    dependencies = [ coreutils wob wireplumber ];
  };
}
