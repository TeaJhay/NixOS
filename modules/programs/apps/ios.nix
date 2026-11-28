{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.sys.apps.ios;
in {
  options.sys.apps.ios.enable = mkEnableOption "ios: iOS sideloading module";
  config = mkIf cfg.enable {
    services.usbmuxd.enable = true;
    environment.systemPackages = with pkgs; [
      libimobiledevice
      ifuse
      usbutils
      iloader
    ];
  };
}
