{
  lib,
  pkgs,
  inputs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.sys.apps.zenBrowser;
in {
  options.sys.apps.zenBrowser.enable = mkEnableOption "Zen: Calmer firefox module";
  config = mkIf cfg.enable {
    environment.systemPackages = [
      inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}
