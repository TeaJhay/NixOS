{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  inherit (lib.modules) mkIf mkMerge;
  cfg = config.sys;
in {
  disabledModules = ["programs/tack.nix"];
  config = mkMerge [
    (mkIf (cfg.role == "desktop")
      {
        nix.settings = {
          experimental-features = [
            "flakes"
            "nix-command"
            "pipe-operators"
          ];
        };
        programs = {
          nh = {
            enable = true;
            package = inputs.nh.packages.${pkgs.stdenv.hostPlatform.system}.default;
            clean = {
              enable = true;
              extraArgs = "--keep-since 5d --keep 20";
            };
            flake = "/persistent/home/teajhay/nixos"; # sets NH_OS_FLAKE variable for you
          };
          tack = {
            enable = true;
            nixConfTokens = true;
          };
        };
      })
  ];
}
