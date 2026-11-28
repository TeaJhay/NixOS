{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption;
  inherit (lib.modules) mkIf mkMerge;
  inherit (lib.lists) any;
  inherit (lib.strings) hasPrefix;
  inherit (config.sys.hardware) modules;

  cfg = config.sys.cli.btop;

  isNvidia = any (hasPrefix "gpu/nvidia") modules;
  isAmd = any (hasPrefix "gpu/amd") modules;
in {
  options.sys.cli.btop.enable = mkEnableOption "btop: A monitor of resources";

  config = mkIf cfg.enable (mkMerge [
    {
      environment.systemPackages = [
        (
          if isNvidia
          then pkgs.btop-cuda
          else if isAmd
          then pkgs.btop-rocm
          else pkgs.btop
        )
      ];
    }
  ]);
}
