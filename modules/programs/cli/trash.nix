{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.sys.cli.trash;
in {
  options.sys.cli.trash.enable = mkEnableOption "trash-cli: ''rm'' replacement module";
  config = mkIf cfg.enable {
    environment = {
      systemPackages = [pkgs.trash-cli];
      shellAliases = {
        rem = "trash-put";
      };
    };
  };
}
