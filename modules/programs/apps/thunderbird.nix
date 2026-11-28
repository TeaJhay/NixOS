{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.sys.apps.thunderbird;
in {
  options.sys.apps.thunderbird.enable = mkEnableOption "Thunderbird: mozilla mail client";
  config = mkIf cfg.enable {
    programs.thunderbird.enable = true;
  };
}
