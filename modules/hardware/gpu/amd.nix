{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (config.host.system.hardware) modules;
  inherit (lib.modules) mkIf mkMerge;
  inherit (lib.lists) elem any;
  inherit (lib.strings) hasPrefix;
in
  # TODO: Make gpu/amd elem, and ensure sub hardware configs can still take
  # effect without forcing full gpu stack onto machine
  mkIf (any (s: hasPrefix "gpu/amd" s) modules) (mkMerge [
    {
      users.extraGroups = ["video"];
      environment.variables.AMD_VULKAN_ICD = "RADV";
      environment.variables.VDPAU_DRIVER = "radeonsi";
      hardware.amdgpu.initrd.enable = true;
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
          libva
          libva-vdpau-driver
          libvdpau-va-gl
        ];
        extraPackages32 = with pkgs.driversi686Linux; [
          libva-vdpau-driver
          libvdpau-va-gl
        ];
      };
    }
    (mkIf (elem "gpu/amd/overclock" modules) {
      hardware.amdgpu.overdrive = {
        enable = true;
        ppfeaturemask = "0xffffffff";
      };
      services.lact.enable = true;
    })
  ])
