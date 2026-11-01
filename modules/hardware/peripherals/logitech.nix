{
  lib,
  config,
  ...
}: let
  inherit (lib) elem;
  inherit (lib.modules) mkIf;
in
  mkIf (elem "peripherals/logitech" config.host.system.hardware.modules) {
    hardware.logitech.wireless.enable = true;
    services.ratbagd.enable = true;
    programs.solaar.enable = true;
  }
