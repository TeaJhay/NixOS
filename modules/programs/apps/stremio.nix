{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.sys.apps.stremio;
in {
  options.sys.apps.stremio.enable = mkEnableOption "Stremio: debrid media client";
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      stremio-linux-shell
    ];
  };
}
