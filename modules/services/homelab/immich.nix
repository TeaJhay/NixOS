{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkMerge mkIf;
  cfg = config.homelab.immich;
  host = config.sys.services;
in {
  config = mkMerge [
    (mkIf (host.immich.enable or false) {
      services.immich = {
        enable = true;
        host = cfg.ipv4;
        inherit (cfg) port;
      };
      networking.firewall = {
        allowedTCPPorts = [cfg.port];
      };
    })
    {
      services.caddy.virtualHosts.${cfg.url}.extraConfig = ''
        import lan_only
        import security_headers
        reverse_proxy ${cfg.ipv4}:${toString cfg.port}
      '';
    }
  ];
}
