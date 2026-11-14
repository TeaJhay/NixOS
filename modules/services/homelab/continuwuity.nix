{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  inherit (lib.modules) mkMerge mkIf;
  cfg = config.homelab.continuwuity;
  host = config.sys.services;
  secrets = config.security.nix-secrets.secrets;
  url = cfg.subDomain + "." + cfg.baseDomain;
in {
  config = mkMerge [
    (mkIf (host.matrix.enable or false) {
      services.matrix-continuwuity = {
        enable = true;
        package = inputs.continuwuity.packages.${pkgs.stdenv.hostPlatform.system}.max-perf-haswell.overrideAttrs {
          doCheck = false;
        };
        settings = {
          global = {
            server_name = "doesntcompute.site";
            well_known = {
              client = "https://${cfg.subDomain}.${cfg.baseDomain}";
              server = "${cfg.subDomain}.${cfg.baseDomain}:443";
            };
            address = ["0.0.0.0"];
            port = [8008];
            allow_announcements_check = true;
            allow_encryption = true;
            allow_federation = true;
            allow_registration = true;
            allow_legacy_media = true;
            max_request_size = 2000000;
            registration_token_file = secrets."Matrix-NixLC/token_file".path;

            # No suffix
            new_user_displayname_suffix = "";

            # IPv4 Querying Only
            ip_lookup_strategy = 1;

            # Just in case
            forbidden_remote_server_name = [];
            prevent_media_downloads_from = [];
            forbidden_remote_room_directory_server_names = [];

            # Experimental MSC's
            allow_sticky_events = true;
            # Continuwuity listens on localhost by default,
            # address and port are handled automatically

            # You can add any further configuration here, e.g.
            # trusted_servers = [ "matrix.org" ];
          };
        };
      };
      environment.extraInit = ''
        export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/podman/podman.sock"
      '';
      virtualisation = {
        oci-containers = {
          backend = "podman";
          containers = {
            mautrix-discord = {
              image = "dock.mau.dev/mautrix/discord:latest";
              podman.user = "admin";
              ports = ["29334:29334"];
              autoStart = true;
              volumes = [
                ".:/data"
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
      networking.firewall = {
        allowedTCPPorts = [8008 29334];
      };
    })
    {
      services.caddy.virtualHosts = {
        discord-media.${cfg.baseDomain} = ''
          reverse_proxy 10.0.1.109:29334
        '';
        mautrix-discord.${cfg.baseDomain} = ''
          reverse_proxy 10.0.1.109:29334
        '';
        ${url}.extraConfig = ''
          handle /_matrix/media/*/download/discord-media.${cfg.baseDomain}/* {
          	# The redirect must have CORS headers to let web clients follow it.
          	header Access-Control-Allow-Origin *
          	# Need to use a route directive to make the uri mutations apply before redir
          	route {
          		# Remove path prefix
          		uri path_regexp ^/_matrix/media/.+/download/discord-media\.doesntcompute\.site/ /
          		# The mxc patterns use | instead of /, so replace it first turning the path into attachments/1234/5678/filename.png
          		uri replace "%7C" /
          		# Then redirect to cdn.discordapp.com/attachments/1234/5678/filename.png with HTTP 307
          		redir https://cdn.discordapp.com{uri} 307
          	}
          }
          # Special-case stickers because they don't have CORS headers on cdn.discordapp.com for some reason
          handle /_matrix/media/*/download/discord-media.${cfg.baseDomain}/stickers|* {
          	header Access-Control-Allow-Origin *
          	route {
          		uri path_regexp ^/_matrix/media/.+/download/discord-media\.doesntcompute\.site/ /
          		uri replace "%7C" /
          		redir https://media.discordapp.net{uri} 307
          	}
          }
          # Do the same for thumbnails, but redirect to media.discordapp.net (which is Discord's thumbnailing server, and happens to use similar width/height params as Matrix)
          /* Alternatively, you can point this at cdn.discordapp.com too. Clients shouldn't mind even if they get a bigger image than they asked for. */
          handle /_matrix/media/*/thumbnail/discord-media.doesntcompute.site/* {
          	header Access-Control-Allow-Origin *
          	route {
          		uri path_regexp ^/_matrix/media/.+/thumbnail/discord-media\.doesntcompute\.site/ /
          		uri replace "%7C" /
          		redir https://media.discordapp.net{uri} 307
          	}
          }

          @public path /_matrix/federation/* /_matrix/key/* /_matrix/client/* /_matrix/media/* /_matrix/server/* /_continuwuity/*
          handle @public {
          	reverse_proxy ${cfg.ipv4}:${cfg.port} {
          		header_down Access-Control-Allow-Origin *
          		header_down Access-Control-Expose-Headers "Content-Length, Content-Range, Content-Disposition"
          	}
          }

          handle {
          	reverse_proxy https://app.sable.moe
          }
        '';
      };
    }
  ];
}
