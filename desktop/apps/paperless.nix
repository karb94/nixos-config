# paperless-ngx
{ lib, primaryUser, ... }:
{
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
  services = {
    paperless =
      let
        paperlessDir = "/data/documents/paperless";
      in
        {
        enable = true;
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
          PAPERLESS_FILENAME_FORMAT = "{tag_list}/{title}";
        };
      };
  };

  # Do not start the services on startup
  systemd.services.paperless-scheduler = {
    wantedBy = lib.mkForce [];
    wants = lib.mkForce [];
    requires = lib.mkForce [
      "paperless-consumer.service"
      "paperless-web.service"
      "paperless-task-queue.service"
    ];
  };
  # Let users in the paperless group access the app and directories
  # systemd.services.paperless-scheduler.serviceConfig.UMask = lib.mkForce "0026";
  # systemd.services.paperless-web.serviceConfig.UMask = lib.mkForce "0026";
  systemd.services.paperless-task-queue.serviceConfig.UMask = lib.mkForce "0026";
  # systemd.services.paperless-consumer.serviceConfig.UMask = "0026";

  users.users."${primaryUser}".extraGroups = [ "paperless" ];
  users.users.paperless.extraGroups = [ "redis-paperless" ];
}
