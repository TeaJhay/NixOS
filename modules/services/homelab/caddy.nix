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
        email = "admin@doesntcompute.site";
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
      environment.extraInit = ''
        export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/podman/podman.sock"
      '';
      virtualisation = {
        oci-containers = {
          backend = "podman";
          containers = {
            caddy-ui-backend = {
              environment = {
                CADDY_UI_EXTERNAL_URL = "http://${cfg.ipv4}:${cfg.port}";
                TZ = "Australia/Brisbane";
              };
              image = "docker.io/zackwag/caddy-ui-backend:latest";
              podman.user = "admin";
              ports = ["3001:3001"];
              autoStart = true;
              extraOptions = [ "--network=caddy-ui" ];
              volumes = [
                "/run/podman/podman.sock:/var/run/docker.sock"
                "/podman/caddy/ui:/etc/caddy-ui"
                "/podman/caddy/data:/data/caddy"
                "/etc/caddy/caddy_config:/etc/caddy/Caddyfile"
                "/podman/caddy/logs:/var/log/caddy"
              ];
            };
            caddy-ui-frontend = {
              dependsOn = ["caddy-ui-backend"];
              podman.user = "admin";
              image = "docker.io/zackwag/caddy-ui-frontend:latest";
              autoStart = true;
              ports = ["9877:80"];
              extraOptions = [
                "--network=caddy-ui"
                "--dns-option=ndots:0"
              ];
            };
          };
        };
        podman = {
          enable = true;
          autoPrune.enable = true;
          # Create a `docker` alias for podman, to use it as a drop-in replacement
          dockerCompat = true;
          # Required for containers under podman-compose to be able to talk to each other.
          defaultNetwork.settings.dns_enabled = true;
        };
      };
      systemd = {
      tmpfiles.rules = [
        "d /podman/caddy 0755 admin users -"
        "d /podman/caddy/logs 0755 admin users -"
        "d /podman/caddy/data 0755 admin users -"
        "d /podman/caddy/config 0755 admin users -"
        "d /podman/caddy/ui 0755 admin users -"
      ];
services = {
create-caddy-ui-network = {
  wantedBy = [ "multi-user.target" ];
  before = [
    "podman-caddy-ui-backend.service"
    "podman-caddy-ui-frontend.service"
  ];
  serviceConfig = {
    Type = "oneshot";
    RemainAfterExit = true;
  };
  script = ''
    ${pkgs.podman}/bin/podman network exists caddy-ui || \
      ${pkgs.podman}/bin/podman network create caddy-ui
  '';
};
podman-caddy-ui-backend = {
  after = [ "create-caddy-ui-network.service" ];
  requires = [ "create-caddy-ui-network.service" ];
};
podman-caddy-ui-frontend = {
  after = [ "create-caddy-ui-network.service" ];
  requires = [ "create-caddy-ui-network.service" ];
};
};
      }''
      networking.firewall = {
        allowedTCPPorts = [80 2019 443 3001];
        allowedUDPPorts = [9877];
      };
    })
    {
      services.caddy.virtualHosts.${url}.extraConfig = ''
        reverse_proxy ${cfg.ipv4}:${cfg.port}
      '';
    }
  ];
}
