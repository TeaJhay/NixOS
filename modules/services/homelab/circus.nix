{
  lib,
  config,
  inputs,
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
  imports = [inputs.circus.nixosModules.default];
  options.host.system.services.circus = {
    enable = mkEnableOption "Enable manic-systems funny CI builder and cache";
    url = mkOption {
      type = str;
      default = "cache.${cfg.baseDomain}";
    };
  };
  config = mkMerge [
    (mkIf cfg.circus.enable {
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
            upstreams = [
              {
                url = "https://cache.manic.systems";
                public_key = "cache.manic.systems-1:s6OZanN8Us8vRi0jVivP3qlMn0cYHBjBALKrNe5nH8s=";
              }
              {
                url = "https://nix-community.cachix.org";
                public_key = "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";
              }
              {
                url = "https://cache.nixos.org";
                public_key = "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=";
              }
            ];
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
        };
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
