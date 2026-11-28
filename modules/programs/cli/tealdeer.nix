{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.sys.cli.tealdeer;
in {
  options.sys.cli.tealdeer.enable = mkEnableOption "tealdeer: ''man'' replacement module";
  config = mkIf cfg.enable {
    environment = {
      systemPackages = [pkgs.tealdeer];
    };
  };
}
