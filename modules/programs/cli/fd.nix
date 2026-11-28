{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.sys.cli.fd;
in {
  options.sys.cli.fd.enable = mkEnableOption "fd: ''find'' replacement module";
  config = mkIf cfg.enable {
    environment = {
      systemPackages = [pkgs.fd];
    };
  };
}
