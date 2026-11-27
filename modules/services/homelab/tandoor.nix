{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkMerge mkIf;
  cfg = config.homelab.tandoor;
  host = config.sys.services;
in {
  config = mkMerge [
    (mkIf (host.tandoor.enable or false) {
      services.tandoor-recipes = {
        enable = true;
        inherit (cfg) port;
        address = cfg.ipv4;
        extraConfig = {
          ENABLE_SIGNUP = "1";
          ALLOWED_HOSTS = cfg.url;
        };
      };
      networking.firewall.allowedTCPPorts = [cfg.port];
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
