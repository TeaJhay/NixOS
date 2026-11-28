{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.sys.cli.ripgrep;
in {
  options.sys.cli.ripgrep.enable = mkEnableOption "ripgrep: ''grep'' replacement module";
  config = mkIf cfg.enable {
    environment = {
      systemPackages = [pkgs.ripgrep];
    };
  };
}
