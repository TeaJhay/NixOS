{
  lib,
  inputs,
  config,
  hostName,
  ...
}: let
  inherit (lib.modules) mkMerge mkIf;
  cfg = config.homelab.trilium;
  host = config.sys.services;
  secrets = config.security.nix-secrets.secrets;
in {
  config = mkMerge [
    (mkIf (host.trilium.enable or false) {
      services.trilium-server = {
        package = inputs.trilium.packages.x86_64-linux.server;
        enable = true;
        host = cfg.ipv4;
        inherit (cfg) port;
        environmentFile = secrets."${hostName}/trilium-env".path;
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
