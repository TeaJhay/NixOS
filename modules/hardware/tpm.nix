{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf elem;
in
  mkIf (elem "tpm" config.host.system.hardware.modules) {
    security.tpm2 = {
      enable = true;
      pkcs11.enable = true;
    };
  }
