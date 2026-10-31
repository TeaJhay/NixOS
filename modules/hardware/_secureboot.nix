{
  self,
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib.lists) elem;
  inherit (lib.modules) mkIf mkForce;
in {
  #imports = [self.modules.lanzaboote.lanzaboote];

  # NOTE: Don't enable until keys have been setup
  config = mkIf (elem "secureboot" config.host.system.hardware.modules) {
    boot = {
      loader.systemd-boot.enable = mkForce false;
      lanzaboote = {
        enable = true;
        autoGenerateKeys.enable = true;
        autoEnrollKeys = {
          enable = true;
          # Automatically reboot to enroll the keys in the firmware
          autoReboot = true;
        };
        pkiBundle = "/var/lib/sbctl";
      };
    };
    environment.systemPackages = [pkgs.sbctl];
  };
}
