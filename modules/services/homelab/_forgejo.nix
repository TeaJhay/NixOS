{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  inherit (lib.modules) mkMerge mkIf;
  cfg = config.homelab.forgejo;
  host = config.sys.services;
  secrets = config.security.nix-secrets.secrets;
  url = cfg.subDomain + "." + cfg.baseDomain;
in {
  config = mkMerge [
    (mkIf (host.forgejo.enable or false) {
      services.forgejo = {
      };
    })
  ];
}
