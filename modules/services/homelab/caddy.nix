{
  lib,
  pkgs,
  config,
  hostName,
  ...
}: let
  inherit (lib.modules) mkMerge mkIf;
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.types) str;
  cfg = config.host.system.services;
  secrets = config.security.nix-secrets.secrets;
  url = cfg.circus.url;
in {
  options.host.system.services.caddy = {
    enable = mkEnableOption "enable caddy reverse-proxy and webserver, in addition to Caddy/ui";
    url = mkOption {
      type = str;
      default = "caddy.${cfg.baseDomain}";
    };
  };
  config = mkMerge [
    (mkIf cfg.caddy.enable {
      services.caddy = {
        enable = true;
        environmentFile = secrets."${hostName}/env".path;

        package = pkgs.caddy.withPlugins {
          plugins = [
            # NOTE: not pinned
            "github.com/caddy-dns/cloudflare@v0.2.4"
            "github.com/mholt/caddy-l4@v0.1.2"
          ];
          # TODO: INVESTIGATE HASH
          hash = "sha256-eGv+I4CceOEqWrMs5fTWPrTF3DBXtB+0vu3Ndw4yArE=";
        };
        logFormat = lib.mkForce "level  INFO";
        globalConfig = ''
          metrics
          	admin 0.0.0.0:2019
          	email admin@doesntcompute.site
          	acme_dns cloudflare {env.CLOUDFLARE_API_TOKEN}
        '';
        extraConfig = ''
                    (lan_only) {
          	@outside not remote_ip 10.0.0.0/8
          	abort @outside
          }

          (security_headers) {
          	header {
          		X-Content-Type-Options "nosniff"
          		X-Frame-Options "SAMEORIGIN"
          		Referrer-Policy "strict-origin-when-cross-origin"
          	}
          }
        '';
      };
    })
    {
      virtualisation.oci-containers.containers = {
        caddy-ui-backend = {
          image = "zackwag/caddy-ui-backend:latest";
          ports = ["9876:3001"];
          volumes = [
            "/var/run/docker.sock:/var/run/docker.sock"
            "/var/lib/caddy-ui:/etc/caddy-ui"
          ];
          environment = {
            TZ = "Australia/Brisbane";
            CADDY_UI_EXTERNAL_URL = "http://${cfg.ipv4}:${cfg.port}";
          };
        };
        caddy-ui-frontend = {
          image = "zackwag/caddy-ui-frontend:latest";
          ports = ["9877:80"];
          dependsOn = ["caddy-ui-backend"];
        };
      };
    }
    {
      services.caddy.virtualHosts.${url}.extraConfig = ''
        reverse_proxy ${cfg.ipv4}:${cfg.port}
      '';
    }
  ];
}
