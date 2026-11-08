{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption mkIf;
  inherit (lib.types) listOf either str attrs;
  cfg = config.host.system.impermanence;
  virtual = config.host.system.virtual;
  cfgUser = config.host.system.impermanence.user;
in {
  imports = [
    inputs.nixos-core.nixosModules.default
    {
      system.nixos-core = {
        enable = true;
        components = {
          bootStage1.enable = false;
          extraUtilsCommand.enable = false;
          initialRamdisk.enable = false;
          nixosInitCompat.enable = true;
          bootloaderInstaller = mkIf virtual.enable {
            enable = false;
          };
        };
      };
    }
  ];
  options.host.system = {
    impermanence = {
      enable = mkEnableOption "enable ephemeral root on this device";
      user = mkOption {
        type = str;
        description = "User whose contents to persist";
      };
      directories = mkOption {
        type = listOf (either str attrs);
        description = "List of directories to persist";
      };
      files = mkOption {
        type = listOf (either str attrs);
        description = "List of files to persist";
      };
    };
  };
  config = mkIf cfg.enable {
    boot = {
      initrd = {
        availableKernelModules = [
          "nvme"
          "xhci_pci"
          "ahci"
          "usb_storage"
          "sd_mod"
        ];
        systemd.services.rollback-void = {
          after = ["dev-disk-by\\x2dpartlabel-disk\\x2dmain\\x2droot.device"];
          before = ["sysroot.mount"];
          description = "Roll back @void root subvolume to blank snapshot";
          path = [
            pkgs.btrfs-progs
            pkgs.coreutils
            pkgs.gawk
            pkgs.util-linux
          ];
          script = ''
            mkdir -p /mnt
            mount /dev/disk/by-partlabel/disk-main-root /mnt
            for sub in $(btrfs subvolume list -o /mnt/@void 2>/dev/null | awk '{print $NF}' | sort -r); do
                btrfs subvolume delete "/mnt/$sub" || true
            done
            btrfs subvolume delete /mnt/@void
            btrfs subvolume snapshot /mnt/@void-blank /mnt/@void
            umount /mnt
          '';
          serviceConfig.Type = "oneshot";
          unitConfig.DefaultDependencies = "no";
          wantedBy = ["initrd.target"];
        };
      };
      kernelModules = [
        "kvm-amd"
      ];
    };
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    fileSystems = {
      "/nix".neededForBoot = true;
      "/persistent".neededForBoot = true;
      "/persistent/home".neededForBoot = true;
    };
    #       ┌─────────────────────────┐
    #       │       Preservation      │
    #       └─────────────────────────┘

    boot.tmp.cleanOnBoot = true;
    boot.tmp.useTmpfs = false;
    system.nixos-core.persistence = {
      enable = true;
      stores."/persistent" = {
        directories = [
          "/etc/ssh"
          "/var/lib/flatpak"
          "/var/lib/sbctl"
          "/var/lib/tailscale"
          "/var/log"
          "/var/lib/OpenLinkHub"
          {
            directory = "/etc/nixos";
            group = "wheel";
            mode = "0775";
          }
        ];
        users.${cfgUser} = {
          inherit (cfg) directories;
          inherit (cfg) files;
        };
      };
    };
    security.sudo.extraConfig = "Defaults lecture=never";
    systemd.suppressedSystemUnits = ["systemd-machine-id-commit.service"];
  };
}
