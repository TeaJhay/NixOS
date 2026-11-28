{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption;
  cfg = config.sys.cli.zoxide;
in {
  options.sys.cli.zoxide.enable = mkEnableOption "zoxide: ''cd'' replacement module";
  config.programs.zoxide = {
    inherit (cfg) enable;
    flags = ["--cmd cd"];
  };
}
