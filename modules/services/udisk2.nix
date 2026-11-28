{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.sys.services.udisk2;
in {
  #options.sys.services.udisk2.enable = mkEnableOption "udisk2: disk mounting service. Mounts to /media/";
  config = mkIf cfg.enable {
    services = {
      udisks2 = {
        enable = true;
        mountOnMedia = true;
      };
    };
    environment.systemPackages = [pkgs.udiskie];
  };
}
