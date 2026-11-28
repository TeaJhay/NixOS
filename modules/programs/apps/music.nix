{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.sys.apps.music;
in {
  options.sys.apps.music.enable = mkEnableOption "Music suite: Music listening, pear-desktop";
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      pear-desktop
    ];
  };
}
