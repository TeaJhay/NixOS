{
  lib,
  config,
  options,
  ...
}: let
  inherit (lib) mkOption;
  inherit (lib.types) enum listOf str;
in {
  options.host.system = {
    hardware = {
      platform = mkOption {
        type = enum [
          "x86_64-linux"
          "aarch64-linux"
          "i686-linux"
          "armv7l-linux"
        ];
        default = null;
        description = "Systems platform";
      };
      hardware = mkOption {
        type = listOf str;
        default = [];
        description = "List of hardware modules this device has ";
      };
    };
  };
}
