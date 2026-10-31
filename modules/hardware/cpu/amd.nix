{
  lib,
  config,
  ...
}: let
  inherit (config.host.system.hardware) modules;
  inherit (lib.modules) mkIf mkMerge mkDefault;

  inherit (lib.lists) elem any;
  inherit (lib.strings) hasPrefix;
in
  mkIf (any (s: hasPrefix "cpu/amd" s) modules) (mkMerge [
    {
      boot.kernelParams = ["amd_pstate=active"];
      hardware.cpu.amd.updateMicrocode = mkDefault config.hardware.enableRedistributableFirmware; # TODO: AMD Cpu
    }

    # TODO: Test if this is even relevant
    (mkIf (elem "cpu/amd/igpu" modules) {
      boot.kernelParams = ["amdgpu.sg_display=0"];
    })

    (mkIf (elem "cpu/amd/zenpower" modules) {
      boot = {
        blacklistedKernelModules = ["k10temp"];
        extraModulePackages = [config.boot.kernelPackages.zenpower];
        kernelModules = ["zenpower"];
      };

      # assertions = [
      #   {
      #     # TODO: Review this conditional
      #     assertion = config.boot.kernelPackages != pkgs.cachyosKernels.linuxPackages-cachyos-bore-lto-zen4;
      #     message = "Zenpower is incompatible with CachyOS Kernel";
      #   }
      # ];
    })
  ])
