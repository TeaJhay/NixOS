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

        environmentFile = secrets."Vaultwarden-NixLC/env".path;
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
          SSO_ENABLED = false;

          EXPERIMENTAL_CLIENT_FEATURE_FLAGS = "ssh-key-vault,pm-34171-card-scanner,pm-32009-new-item-types,ssh-agent-v2,pm-30529-webauthn-related-origins";
        };

        # TODO: Add reverse proxy config if using one
        # Could also sneak this into evies config since hosting on 192.168.0.0/16
        # Changing this to lastname.org and using another machine
        # For reverse proxy doesn't seem viable at the moment since i only get
        # forwarding for 80/443 to one machine in the lab
      };
    })
  ];
}
