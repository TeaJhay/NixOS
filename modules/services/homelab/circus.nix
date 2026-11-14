{
  lib,
  config,
  inputs,
  hostName,
  substituters,
  ...
}: let
  inherit (lib.modules) mkMerge mkIf;
  cfg = config.homelab.circus;
  host = config.sys.services;
  secrets = config.security.nix-secrets.secrets;
  url = cfg.subDomain + "." + cfg.baseDomain;
in {
  imports = [inputs.circus.nixosModules.default];
  config = mkMerge [
    (mkIf (host.circus.enable or false) {
      services.circus = {
        enable = true;

        server.enable = true;
        evaluator.enable = true;
        queueRunner.enable = true;

        settings = {
          database.url = "postgresql:///circus?host=/run/postgresql&user=circus";
          server = {
            host = "0.0.0.0";
            inherit (cfg) port;
            force_secure_cookies = false;
            rate_limit_rps = 200;
            rate_limit_burst = 200;
            cors_permissive = false;
            openapi_enabled = false; # Disable the api for now. (I make no use of it)
            require_api_key_for_reads = false;
          };
          ui = {
            brand_name = "Doesntcompute CI";
            brand_subtitle = "Clownfest";
            logo_url = "https://avatars.githubusercontent.com/u/287464793?s=200&v=4";
            favicon_url = "https://avatars.githubusercontent.com/u/287464793?s=200&v=4";
          };
          evaluator = {
            allow_ifd = false;
            strict_errors = true;
            restrict_eval = false;
            nix_timeout = 43200;
            # Accounting for memory_limit_mb * eval_workers * max_conccurrent_evals
            eval_workers = 4;
            max_concurrent_evals = 2;
            memory_limit_mb = 4096; # This might be too low, but doubling it technically uses all of centrifuges ram
          };

          queue_runner.workers = 8;
          queue_runner.build_timeout = 7200;

          gc.enabled = true;
          gc.max_age_days = 5;
          cache = {
            enabled = true;
            cache_url = "https://cache.${cfg.baseDomain}/nix-cache";
            upstreams = map (upstream: {inherit (upstream) url public_key;}) substituters;
          };
          logs.log_dir = "/var/lib/circus/logs";
          logs.compress = true;
          declarative = {
            users = [
              {
                username = "teajhay";
                email = "git@doesntcompute.site";
                password_file = secrets."${hostName}/circus_password".path;
                role = "admin";
              }
            ];
            api_keys = [
              {
                name = "admin-key";
                key_file = secrets."${hostName}/circus_api".path;
                role = "admin";
              }
            ];
          };
          signing = {
            enabled = true;
            key_file = secrets."${hostName}/circus_signing".path;
            public_key = "cache.${cfg.baseDomain}-1:cTv/ePA602QGzUci4rMdYGkuS4LA0NzEjoWnaHAwvAg=";
          };
          tracing = {
            level = "debug";
            format = "compact";
            show_targets = true;
            show_timestamps = true;
          };
          notifications = {
            email = {
              smtp_host = "mail-au.smtp2go.com";
              smtp_port = 465;
              smtp_user = "homelab@${cfg.baseDomain}";
              smtp_password_file = secrets."${hostName}/smtp_password".path;
              tls = true;
              from_address = "circus@${cfg.baseDomain}";
              to_addresses = ["admin@${cfg.baseDomain}"];
              on_failure_only = true;
            };
          };
          oauth.oidc.authentik = {
            display_name = "Authentik";
            client_id = "OpH9NATX5jjIshEPyonVPBaiMBgS4oV5ZvRVi5Bx";
            client_secret_file = secrets."${hostName}/circus_oidc_secret".path;
            redirect_uri = "https://cache.doesntcompute.site/api/v1/auth/oidc/authentik/callback";
            issuer_url = "https://auth.doesntcompute.site/application/o/circus/";
          };
        };
      };
      networking.firewall = {
        allowedTCPPorts = [cfg.port];
      };
    })
    {
      services.caddy.virtualHosts.${url}.extraConfig = ''
        @nix path /nix-cache-info /*.narinfo /nar/* /log/* /realisations/*

        handle @nix {
        	rewrite * /nix-cache{uri}
        	reverse_proxy ${cfg.ipv4}:${cfg.port}
        }

        handle {
        	reverse_proxy ${cfg.ipv4}:${cfg.port}
        }
      '';
    }
  ];
}
