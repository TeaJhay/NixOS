{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.sys.apps.onlyOffice;
in {
  options.sys.apps.onlyOffice.enable = mkEnableOption "onlyOffice: foss document editor";
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      onlyoffice-desktopeditors
    ];
  };
}
