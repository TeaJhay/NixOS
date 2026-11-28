{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.sys.gaming.prismLauncher;
in {
  options.sys.gaming.prismLauncher.enable = mkEnableOption "prismLauncher: Minecraft launcher";
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      (prismlauncher.override {
        jdks = with pkgs; [
          temurin-bin-8 # MC 1.7–1.12
          temurin-bin-17 # MC 1.17–1.20
          temurin-bin-21 # MC 1.20.5+
          #temurin-bin-26
          temurin-bin-27 # for GTNH, if doesn't work fallback to 26
        ];
      })
    ];
  };
}
