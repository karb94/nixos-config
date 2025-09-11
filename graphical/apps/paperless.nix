# paperless-ngx
{
  pkgs,
  # pkgs-unstable,
  pkgs-paperless,
  lib,
  primaryUser,
  ...
}:
{
  options = {
    services.paperless.desktopItem = lib.mkOption {
      # type = lib.types.desktopItem;
      description = "Desktop entry to launch the paperless service";
    };
  };

  config = {
    services.postgresql = {
      enable = true;
      ensureDatabases = [ "paperless" ];
      ensureUsers = [
        {
          name = "paperless";
          ensureDBOwnership = true;
        }
      ];
    };
    services.paperless =
      let
        paperlessDir = "/data/documents/paperless";
      in
      {
        enable = true;
        package = pkgs-paperless.paperless-ngx;
        mediaDir = "${paperlessDir}/media";
        consumptionDir = "${paperlessDir}/consume";
        port = 8000;
        settings = {
          settings.PAPERLESS_AUTO_LOGIN_USERNAME = "admin";
          PAPERLESS_DBHOST = "/run/postgresql";
          # Disable login for the web interface
          PAPERLESS_AUTO_LOGIN_USERNAME = primaryUser;
          PAPERLESS_OCR_LANGUAGE = "eng+spa+cat";
          PAPERLESS_OCR_USER_ARGS = {
            optimize = 1;
            pdfa_image_compression = "lossless";
            invalidate_digital_signatures = true;
          };
          PAPERLESS_FILENAME_FORMAT = "{{ tag_list }}/{{ title }}";
        };
        # Create a desktop entry to launch the service
        desktopItem = pkgs.makeDesktopItem {
          name = "paperless";
          exec = "${pkgs.systemd}/bin/systemctl start paperless-scheduler.service";
          icon = ./paperless.svg;
          desktopName = "Paperless";
          genericName = "Launch Paperless";
        };
      };

    # Do not start the services on startup
    systemd.services.paperless-scheduler = {
      wantedBy = lib.mkForce [ ];
      wants = lib.mkForce [ ];
      requires = lib.mkForce [
        "paperless-consumer.service"
        "paperless-web.service"
        "paperless-task-queue.service"
        "redis-paperless.service"
      ];
    };
    systemd.services.redis-paperless.wantedBy = lib.mkForce [ ];

    # Allow users in the paperless group to start the service
    security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (action.id == "org.freedesktop.systemd1.manage-units"
      && subject.isInGroup("paperless")) {
        if (action.lookup("unit") == "paperless-scheduler.service") {
          var verb = action.lookup("verb");
          if (verb == "start" || verb == "stop" || verb == "restart") {
            return polkit.Result.YES;
          }
        }
      }
    });
    '';

    # Let users in the paperless group access the app and directories
    systemd.services.paperless-task-queue.serviceConfig.UMask = lib.mkForce "0026";
    # The other services do not create files so no changes needed
    # systemd.services.paperless-scheduler.serviceConfig.UMask = lib.mkForce "0026";
    # systemd.services.paperless-web.serviceConfig.UMask = lib.mkForce "0026";
    # systemd.services.paperless-consumer.serviceConfig.UMask = "0026";

    users.users."${primaryUser}".extraGroups = [ "paperless" ];
    users.users.paperless.extraGroups = [ "redis-paperless" ];
  };
}
