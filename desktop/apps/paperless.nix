# paperless-ngx
{ primaryUser, ... }:
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
        };
      };
  };
  users.users."${primaryUser}".extraGroups = [ "paperless" ];
}
