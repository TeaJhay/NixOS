{ config, lib, pkgs, inputs, ... }: {
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
        "/etc/nixos"
        "/etc/ssh"
        "/var/lib/flatpak"
        "/var/lib/sbctl"
        "/var/lib/tailscale"
        "/var/log"
        {
          directory = "/var/lib/nixos";
          inInitrd = true;
        }
      ];

      files = [
        {
          file = "/etc/machine-id";
          inInitrd = true;
          how = "symlink;"
        }
      ];
      users.teajhay = {
        directories = [
          ".cache/bat"
          ".config/Epic"
          ".config/Signal"
          ".config/easyeffects"
          ".config/halloy"
          ".config/heroic"
          ".config/jj/repos"
          ".config/libreoffice"
          ".config/mozilla"
          ".config/obs-studio"
          ".config/obsidian"
          ".config/spotify"
          ".config/vesktop"
          ".config/vicinae"
          ".java"
          ".local/share/PrismLauncher"
          ".local/share/Steam"
          ".local/share/Terraria"
          ".local/share/applications"
          ".local/share/com.edde746.plezy"
          ".local/share/direnv"
          ".local/share/fish"
          ".local/share/flatpak"
          ".local/share/heroic"
          ".local/share/icons"
          ".local/share/keyrings"
          ".local/share/nvim"
          ".local/share/qalculate"
          ".local/share/robrix"
          ".local/share/vicinae"
          ".local/share/zoxide"
          ".local/state/wireplumber"
          ".ssh"
          ".steam"
          ".var/app"
          "Desktop"
          "Documents"
          "Downloads"
          "Music"
          "Pictures"
          "Videos"
        ];
      };
    };
  };
  security.sudo.extraConfig = "Defaults lecture=never";
  systemd.suppressedSystemUnits = ["systemd-machine-id-commit.service"];
}
