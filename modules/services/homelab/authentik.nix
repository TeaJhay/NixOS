{
  lib,
  config,
  inputs,
  hostName,
  ...
}: let
  inherit (lib.modules) mkMerge mkIf;
  cfg = config.homelab.authentik;
  host = config.sys.services;
  secrets = config.security.nix-secrets.secrets;
in {
  imports = [inputs.authentik.nixosModules.default];
  config = mkMerge [
    (mkIf (host.authentik.enable or false) {
      services.authentik = {
        enable = true;
        # The environmentFile needs to be on the target host!
        # Best use something like sops-nix or agenix to manage it
        environmentFile = secrets."${hostName}/authentik-env".path;
        settings = {
          email = {
            host = "mail-au.smtp2go.com";
            port = 587;
            username = "homelab@${cfg.baseDomain}";
            use_tls = true;
            use_ssl = false;
            from = "authentik@${cfg.baseDomain}";
          };
          disable_startup_analytics = true;
          avatars = "gravatar";
        };
      };
      networking.firewall = {
        allowedTCPPorts = [3389 6636 1812 9300 9900 9901 9000 9443 9001];
      };
    })
    {
      services.caddy.virtualHosts.${cfg.url}.extraConfig = ''
        reverse_proxy ${cfg.ipv4}:${toString cfg.port}
      '';
    }
  ];
}
