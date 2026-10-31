{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.host.system.preservation;
in {
  imports = [
    inputs.nixos-core.nixosModules.default
    {system.nixos-core.enable = true;}
  ];
  options.host.system = {
    preservation = {
      enable = mkEnableOption "enable ephemeral root on this device";
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
            user = "teajhay";
            group = "users";
            mode = "0775";
          }
        ];

        users.teajhay = {
          directories = [
            ".config/jj/repos"
            ".config/zen"
            ".config/YouTube Music"
            ".config/vesktop"
            ".config/gh"
            ".java"
            ".local/share/direnv"
            ".local/share/PrismLauncher"
            ".local/share/Steam"
            ".local/share/applications"
            ".local/share/krita"
            ".local/share/flatpak"
            ".local/share/icons"
            ".local/share/keyrings"
            ".local/share/nvim"
            ".local/share/stremio"
            ".local/share/zoxide"
            ".local/state/wireplumber"
            ".local/state/noctalia"
            ".local/state/modprobed-db"
            ".local/state/nix/profiles"
            ".ssh"
            ".config/yazi/flavors/noctalia.yazi"
            ".gnupg"
            "Dev/vfs"
            ".thunderbird"
            ".steam"
            ".var/app"
            ".config/millennium"
            ".local/share/millennium"
            ".local/share/heroic"
            ".config/heroic"
            ".cache/tealdeer"
            ".cache/nix"
          ];
          files = [
            ".gitconfig"
            {
              file = ".config/mimeapps.list";
              method = "symlink";
            }
            {
              file = ".config/nvim/lua/matugen.lua";
              method = "symlink";
            }

            {
              file = ".config/nvim/lua/matugen-template.lua";
              method = "symlink";
            }
            {
              file = ".config/kitty/themes/noctalia.conf";
              method = "symlink";
            }
            {
              file = ".zsh_history";
              method = "symlink";
            }
            ".config/jjui/config.toml"
          ];
        };
      };
    };
    security.sudo.extraConfig = "Defaults lecture=never";
    systemd.suppressedSystemUnits = ["systemd-machine-id-commit.service"];
  };
}
