# NOTE: Should be used with ".local/share/modprobed-db/modprobed.db" persisted
{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.sys.services.modprobed;
in {
  #options.sys.services.modprobed.enable = mkEnableOption "modprobed-db: kernel module logging service";
  config = mkIf cfg.enable {
    environment.systemPackages = [pkgs.modprobed-db];
    systemd.services.modprobed-db-store = {
      description = "Snapshot currently loaded kernel modules for modprobed-db";
      path = [pkgs.getent pkgs.gawk];
      serviceConfig = {
        ExecStart = "${pkgs.modprobed-db}/bin/modprobed-db storesilent";
        Type = "oneshot";
      };
    };
    systemd.timers.modprobed-db-store = {
      description = "Timer for modprobed-db snapshot";
      timerConfig = {
        OnBootSec = "1min";
        OnUnitActiveSec = "5min";
      };
      wantedBy = ["timers.target"];
    };
  };
}
