{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.sys.apps.photo;
in {
  options.sys.apps.photo.enable = mkEnableOption "Photo suite: Photo viewing and editing suite, krita + oculante";
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      krita
      oculante
    ];
  };
}
