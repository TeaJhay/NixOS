{
  lib,
  config,
  ...
}: let
  inherit (config.sys.hardware) modules;
  inherit (lib.modules) mkIf mkMerge;
  inherit (lib.lists) any;
  inherit (lib.strings) hasPrefix;
  cfg = config.sys;
in
  mkIf (cfg.role == "kvm-virt") (mkMerge [
    {
      boot.initrd.availableKernelModules = [
        "ata_piix"
        "uhci_hcd"
        "virtio_pci"
        "virtio_scsi"
        "sd_mod"
        "sr_mod"
      ];
    }

    (mkIf (any (s: hasPrefix "cpu/amd" s) modules) {
      boot.kernelModules = ["kvm-amd"];
    })

    (mkIf (any (s: hasPrefix "cpu/intel" s) modules) {
      boot.kernelModules = ["kvm-intel"];
    })
  ])
