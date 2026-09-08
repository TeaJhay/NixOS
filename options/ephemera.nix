{
  lib,
  pkgs,
  ...
}:
{
  #       ┌─────────────────────────┐
  #       │       impermanence      │
  #       └─────────────────────────┘

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
        after = [ "dev-disk-by\\x2dpartlabel-disk\\x2dmain\\x2droot.device" ];
        before = [ "sysroot.mount" ];
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
        wantedBy = [ "initrd.target" ];
      };
    };
    kernelModules = [
      "kvm-amd"
    ];
  };
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  fileSystems."/nix".neededForBoot = true;
  fileSystems."/persistent".neededForBoot = true;
  fileSystems."/persistent/home".neededForBoot = true;
  #       ┌─────────────────────────┐
  #       │       Preservation      │
  #       └─────────────────────────┘

  boot.tmp.cleanOnBoot = true;
  boot.tmp.useTmpfs = false;
  preservation = {
    enable = true;
    preserveAt."/persistent" = {
      directories = [
        "/etc/ssh"
        "/var/lib/flatpak"
        "/var/lib/sbctl"
        "/var/lib/tailscale"
        "/var/log"
        {
          directory = "/var/lib/nixos";
          inInitrd = true;
        }
        {
          directory = "/etc/nixos";
          user = "teajhay";
          group = "wheel";
          mode = "u=rwx,g=rwx,o=rx";
        }
      ];

      files = [
        {
          file = "/etc/machine-id";
          inInitrd = true;
        }
      ];
      users.teajhay = {
        directories = [
          ".config/jj/repos"
          ".config/zen"
          ".config/mozilla"
          ".config/spotify"
          ".config/vesktop"
          ".config/gh"
          ".java"
          ".local/share/PrismLauncher"
          ".local/share/Steam"
          ".local/share/applications"
          ".local/share/direnv"
          ".local/share/fish"
          ".local/share/flatpak"
          ".local/share/icons"
          ".local/share/heroic"
          ".local/share/keyrings"
          ".local/share/nvim"
          ".local/share/qalculate"
          ".local/share/robrix"
          ".local/share/vicinae"
          ".local/share/zoxide"
          ".local/state/wireplumber"
          ".local/state/noctalia"
          ".ssh"
          ".thunderbird"
          ".secrets"
          ".steam"
          ".var/app"
        ];
        files = [
          ".gitconfig"
          ".config/mimeapps.list"
        ];
      };
    };
  };
  security.sudo.extraConfig = "Defaults lecture=never";
  systemd.suppressedSystemUnits = [ "systemd-machine-id-commit.service" ];
}
