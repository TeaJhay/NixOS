{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf elem;
in
  mkIf (elem "ssd" config.sys.hardware.modules) {
    services.fstrim.enable = true;
    boot.initrd.availableKernelModules = ["nvme"];
  }
