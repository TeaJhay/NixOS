{
  lib,
  config,
  hostName,
  ...
}: let
  inherit (lib.modules) mkMerge mkIf;
  cfg = config.homelab.tandoor;
  host = config.sys.services;
  secrets = config.security.nix-secrets.secrets;
in {
  config = mkMerge [
    (mkIf (host.tandoor.enable or false) {
      services.tandoor-recipes = {
        inherit (cfg) port;
        address = cfg.url;
        extraConfig = {
          ENABLE_SIGNUP = "1";
        };
        database.createLocally = true;
      };
      networking.firewall.allowedTCPPorts = [cfg.port];
    })
    {
      services.caddy.virtualHosts.${cfg.url}.extraConfig = ''
        reverse_proxy ${cfg.ipv4}:${cfg.port}
      '';
    }
  ];
}
