{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.sys.cli.fzf;
in {
  options.sys.cli.fzf.enable = mkEnableOption "fzf: command-line fuzzy finder";
  config = mkIf cfg.enable {
    environment = {
      systemPackages = [pkgs.fzf];
    };
  };
}
