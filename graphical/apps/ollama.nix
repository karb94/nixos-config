{ pkgs-unstable-small, ... }:
{
  services = {
    ollama = {
      enable = true;
      package = pkgs-unstable-small.ollama;
      acceleration = "rocm";
      models = "/persist/models";
      user = "ollama";
      group = "ollama";
      rocmOverrideGfx = "11.0.0";
    };
    open-webui = {
      enable = true;
      package = pkgs-unstable-small.open-webui;
      environment = {
        WEBUI_AUTH = "False";
        DEFAULT_MODELS = "deepseek-r1:32b";
      };
      host = "0.0.0.0";
      port = 2284;
    };
  };
# Open ports for used apps in your local network
# https://discourse.nixos.org/t/open-firewall-ports-only-towards-local-network/13037/2
# The --source is the LAN block address
# so anything of the form 192.168.1.X/24 will do
  networking.firewall.extraCommands = ''
        iptables -A nixos-fw -p tcp --source 192.168.1.0/24 --dport 2284 -j nixos-fw-accept
  '';
}
