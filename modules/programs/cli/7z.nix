{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.sys.cli.p7z;
in {
  options.sys.cli.p7z.enable = mkEnableOption "p7zip: Archive unpacking and creation tool";
  config = mkIf cfg.enable {
    environment = {
      systemPackages = with pkgs; [p7zip-rar];
    };
  };
}
