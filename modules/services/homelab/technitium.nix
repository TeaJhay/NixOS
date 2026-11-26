{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkMerge mkIf;
  cfg = config.homelab.technitium;
  host = config.sys.services;
in {
  config = mkMerge [
    (mkIf (host.technitium.enable or false) {
      services.technitium-dns-server = {
        enable = true;
      };
      networking.firewall = {
        allowedTCPPorts = [53 5380 53443];
        allowedUDPPorts = [53];
      };
    })
    {
      services.caddy.virtualHosts.${cfg.url}.extraConfig = ''
        reverse_proxy ${cfg.ipv4}:${toString cfg.port}
      '';
    }
  ];
}
