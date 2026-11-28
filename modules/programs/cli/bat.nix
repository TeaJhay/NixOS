{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption;
  cfg = config.sys.cli.bat;
in {
  options.sys.cli.bat.enable = mkEnableOption "bat: ''cat'' replacement module";
  config = {
    programs.bat = {
      inherit (cfg) enable;
    };
    environment.shellAliases = {
      cat = "bat";
    };
  };
}
