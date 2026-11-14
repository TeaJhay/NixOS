{
  lib,
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
      services.firefox-syncserver = {
        enable = true;
        secrets = secrets."${hostName}/sync";
        singleNode = {
          enable = true;
          hostname = hostName;
          enableTLS = true;
          inherit (cfg) url;
        };
      };
      networking.firewall = {
        allowedTCPPorts = [cfg.port];
      };
    })
    {
      services.caddy.virtualHosts.${cfg.url}.extraConfig = ''
        reverse_proxy ${cfg.ipv4}:${cfg.port}
      '';
    }
  ];
}
