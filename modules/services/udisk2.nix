{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkDefault mkIf mkMerge;
  cfg = config.sys.services.udisk2;
in {
  config = mkMerge [
    {
      sys.services.udisk2.enable = mkDefault false;
    }
    (mkIf cfg.enable {
      services = {
        udisks2 = {
          enable = true;
          mountOnMedia = true;
        };
      };
      environment.systemPackages = [pkgs.udiskie];
    })
  ];
}
