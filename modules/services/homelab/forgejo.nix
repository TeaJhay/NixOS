{
  lib,
  config,
  hostName,
  ...
}: let
  inherit (lib.modules) mkMerge mkIf;
  cfg = config.homelab.forgejo;
  host = config.sys.services;
  secrets = config.security.nix-secrets.secrets;
in {
  config = mkMerge [
    (mkIf (host.forgejo.enable or false) {
      services.forgejo = {
        enable = true;
        lfs.enable = true;
        database.type = "sqlite3";
        settings = {
          server = {
            DOMAIN = cfg.url;
            SSH_DOMAIN = "git-ssh.${cfg.baseDomain}";
            SSH_PORT = 22;
            ROOT_URL = "https://${cfg.url}/";
            HTTP_PORT = cfg.port;
            OFFLINE_MODE = true;
            LFS_JWT_SECRET_URI = secrets."${hostName}/lfsJwtSecret".path;
            ALLOW_DOMAIN_3RD_PARTY = true;
          };
          repository = {
            ENABLE_PUSH_CREATE_USER = true;
            ENABLE_PUSH_CREATE_ORG = true;
            DEFAULT_PUSH_CREATE_PRIVATE = true;
          };
          "repository.pull-request" = {
            DEFAULT_MERGE_STYLE = "merge";
          };
          "repository.signing" = {
            DEFAULT_TRUST_MODEL = "committer";
          };
          log = {
            LEVEL = "Trace";
          };
          service = {
            DISABLE_REGISTRATION = true;
            DEFAULT_ALLOW_CREATE_ORGANIZATION = true;
            DEFAULT_ENABLE_TIMETRACKING = true;
            # TODO: Re-enable once mail setup
            ENABLE_NOTIFY_MAIL = true;
            REGISTER_EMAIL_CONFIRM = true;
          };
          openid = {
            ENABLE_OPENID_SIGNIN = true;
          };
          oauth2 = {
            JWT_SECRET_URI = secrets."${hostName}/jwtSecret".path;
          };
          oauth2_client = {
            USERNAME = "email";
          };
          security = {
            INTERNAL_TOKEN_URI = secrets."${hostName}/InternalToken".path;
          };
          mailer = {
            ENABLED = true;
            FROM = "git@${cfg.baseDomain}";
            PROTOCOL = "smtp+starttls";
          };
          secrets = {
            mailer = {
              SMTP_ADDR = secrets."${hostName}/smtpAddr".path;
              SMTP_PORT = secrets."${hostName}/smtpPort".path;
              USER = secrets."${hostName}/user";
              PASSWD = secrets."${hostName}/passwd".path;
            };
          };
        };
      };
      networking.firewall = {
        allowedTCPPorts = [22 80 443];
      };
    })
    {
      services.caddy.virtualHosts.${cfg.url}.extraConfig = ''
        reverse_proxy ${cfg.ipv4}:${cfg.port}
      '';
    }
  ];
}
