{
  lib,
  config,
  hostName,
  ...
}: let
  inherit (lib.modules) mkMerge mkIf;
  cfg = config.homelab.vaultwarden;
  host = config.sys.services;
  secrets = config.security.nix-secrets.secrets;
in {
  config = mkMerge [
    (mkIf (host.vaultwarden.enable or false) {
      services.vaultwarden = {
        enable = true;
        backupDir = "/var/backups/vaultwarden";
        # Using caddy and sqlite
        configureNginx = false;
        configurePostgres = false;

        environmentFile = secrets."${hostName}/env".path;
        config = {
          WEBSOCKET_ENABLED = true;
          SIGNUPS_ALLOWED = true;
          DOMAIN = "https://${cfg.url}/";

          ROCKET_ADDRESS = cfg.ipv4;
          ROCKET_PORT = cfg.port;
          ROCKET_LOG = "critical";

          # NOTE: enable push notificaitons. Keys in env file
          PUSH_ENABLED = true;
          PUSH_RELAY_URI = "https://api.bitwarden.eu";
          PUSH_IDENTITY_URI = "https://identity.bitwarden.eu";
          # NOTE: SMTP settings in env file
          HELO_NAME = hostName;

          TRASH_AUTO_DELETE_DAYS = "30";
          SIGNUPS_VERIFY = true;

          # NOTE: set to true once sso is setup
          SSO_ENABLED = true;

          EXPERIMENTAL_CLIENT_FEATURE_FLAGS = "ssh-key-vault,pm-34171-card-scanner,pm-32009-new-item-types,ssh-agent-v2,pm-30529-webauthn-related-origins";
        };
      };
      networking.firewall = {
        allowedTCPPorts = [cfg.port];
      };
    })
    {
      services.caddy.virtualHosts.${cfg.url}.extraConfig = ''
        header {
        	X-Content-Type-Options "nosniff"
        	Referrer-Policy "strict-origin-when-cross-origin"
        }
        # NPM: "WebSockets Support" is enabled here automatically
        reverse_proxy ${cfg.ipv4}:${cfg.port} {
        	header_up X-Real-IP {http.request.remote.host}
        }
      '';
    }
  ];
}
