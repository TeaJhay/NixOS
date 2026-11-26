{
  lib,
  pkgs,
  config,
  hostName,
  ...
}: let
  inherit (lib.modules) mkMerge mkIf;
  cfg = config.homelab.syncStorage;
  host = config.sys.services;
  secrets = config.security.nix-secrets.secrets;
in {
  config = mkMerge [
    (mkIf (host.syncStorage.enable or false) {
      services.postgresql = {
        enable = true;
        package = pkgs.postgresql_19;
      };
      services.firefox-syncserver = {
        enable = true;
        singleNode = {
          enable = true;
          enableNginx = false;
          enableTLS = true;
          hostname = hostName;
          url = "https://${cfg.url}";

          capacity = 5;
        };
        database.type = "postgresql";
        secrets = secrets."${hostName}/ff-sync".path;
        settings = {
          host = cfg.ipv4;
        };
      };
      networking.firewall = {
        allowedTCPPorts = [cfg.port];
      };
    })
    {
      services.caddy.virtualHosts.${cfg.url}.extraConfig = ''
        reverse_proxy ${cfg.ipv4}:${toString cfg.port}
      '';
    }
  ];
}
