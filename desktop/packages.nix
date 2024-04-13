# Packages to install
{
  lib,
  pkgs,
  config,
  ...
}:
let
generalPkgs = with pkgs; [
    kitty              # Terminal emulator
    alacritty              # Terminal emulator
    brave                  # Web browser
    # citrix_workspace_23_09_0 # Remote desktop
    citrix_workspace       # Remote desktop
    freetube               # FOSS youtube front-end
    ledger-live-desktop    # Crypto wallet
    logseq                 # Note taking app
    mpv                    # Video player
    nsxiv                  # Image viewer
    okular
    spotify                # Music player
    tor-browser-bundle-bin # Secure and private internet browser
    zathura                # PDF viewer
  ];

  cliPkgs = with pkgs; [
    newsboat        # Terminal RSS feed manager
    yt-dlp          # Youtube video downloader
  ];

  # shell_scripts = lib.attrValues (import ./shell_scripts.nix {inherit pkgs lib;});
  shellScripts = import ./scripts pkgs;

in {

  environment.systemPackages = generalPkgs ++ cliPkgs ++ ( lib.attrValues shellScripts );

  systemd.user.services.wob_volume =
    let
      wobInstalled = builtins.elem pkgs.wob config.environment.systemPackages;
    in  lib.mkIf wobInstalled {
      description = "A lightweight overlay bar for Wayland";
      documentation = [ "man:wob(1)" ];
      partOf = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];
      unitConfig = {
        ConditionEnvironment = "WAYLAND_DISPLAY";
      };
      serviceConfig = {
        StandardInput = "socket";
        ExecStart = "${pkgs.wob}/bin/wob";
      };
    };
  systemd.user.sockets.wob_volume =
    let
      wob_volumeInstalled = builtins.elem shellScripts.wob_volume config.environment.systemPackages;
    in  lib.mkIf wob_volumeInstalled {
    wantedBy = [ "sockets.target" ];
    socketConfig = {
      ListenFIFO = "%t/wob_volume.sock";
      SocketMode = "0600";
      RemoveOnStop = "on";
      # If wob exits on invalid input, systemd should NOT shove following input right back into it after it restarts
      FlushPending = "yes";
    };
  };


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
