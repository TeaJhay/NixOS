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
      };
    })
  ];
}
