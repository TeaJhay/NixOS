# NOTE: Should be used with ".local/share/modprobed-db/modprobed.db" persisted
{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkDefault mkIf mkMerge;
  cfg = config.sys.services.modprobed;
in {
  config = mkMerge [
    {
      sys.services.modprobed.enable = mkDefault false;
    }

    (mkIf cfg.enable {
      environment.systemPackages = [pkgs.modprobed-db];

      systemd.user.services.modprobed-db-store = {
        description = "Snapshot currently loaded kernel modules for modprobed-db";
        path = [pkgs.getent pkgs.gawk];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${pkgs.modprobed-db}/bin/modprobed-db storesilent";
        };
      };

      systemd.user.timers.modprobed-db-store = {
        description = "Timer for modprobed-db snapshot";
        wantedBy = ["timers.target"];
        timerConfig = {
          OnStartupSec = "1min";
          OnUnitActiveSec = "5min";
        };
      };
    })
  ];
}
