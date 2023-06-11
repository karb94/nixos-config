# Shell script derivations
{lib, pkgs}: let
  shell_scripts = with pkgs; [
    rec {
      name = "dy";
      dependencies = [yt-dlp mpv jq bspwm libwebp curl file xsel];
      desktopItems = [
        (pkgs.makeDesktopItem {
         name = name;
         exec = script;
         # icon = "gkrellm";
         desktopName = "dy";
         genericName = "Youtube video downloader";
         })
      ];
    }
    {
      name = "link_handler";
      dependencies = [curl gnused nsxiv zathura];
    }
    {
      name = "pair_hp";
      dependencies = [bluez];
    }
    {
      name = "xob_volume";
      dependencies = [xob wireplumber];
    }
  ];
  mkShellScript = import ./mkShellScript.nix pkgs lib;
  f = shell_script: lib.attrsets.nameValuePair shell_script.name (mkShellScript shell_script);
in
  builtins.listToAttrs (map f shell_scripts)
