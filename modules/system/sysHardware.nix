{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkOption;
  inherit (lib.types) listOf strMatching str;
  cfg = config.sys;
in {
  options.sys = {
    hardware = {
      modules = mkOption {
        type = listOf str;
        default = [];
        description = "List of hardware modules this device has ";
      };
      machine-id = mkOption {
        type = strMatching "[0-9a-fA-F]{32}";
        description = "Machine ID of the host, must be A 32-character hexadecimal string.";
        example = "b08dfa6083e7567a1921a715000001fb";
      };
    };
  };

  config =
    mkIf (cfg.enable && !cfg.virtual.enable)
    {
      environment.etc."machine-id".text = cfg.hardware.machine-id;
    };
}
