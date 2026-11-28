{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.sys.cli.kitty;
in {
  options.sys.cli.kitty.enable = mkEnableOption "Kitty: fast, gpu-based terminal emulator";
  config = mkIf cfg.enable {
    environment = {
      systemPackages = [pkgs.kitty];
    };
  };
}
