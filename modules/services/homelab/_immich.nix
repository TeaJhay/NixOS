{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  inherit (lib.modules) mkMerge mkIf;
  cfg = config.homelab.immich;
  host = config.sys.services;
  secrets = config.security.nix-secrets.secrets;
  url = cfg.subDomain + "." + cfg.baseDomain;
in {
  config = mkMerge [
    (mkIf (host.immich.enable or false) {
      services.immich = {
      };
    })
  ];
}
