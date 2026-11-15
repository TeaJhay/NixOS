{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkMerge mkIf;
  cfg = config.homelab.tandoor;
  host = config.sys.services;
  secrets = config.security.nix-secrets.secrets;
in {
  config = mkMerge [
    (mkIf (host.tandoor.enable or false) {
      services.tandoor-recipes = {
      };
    })
  ];
}
