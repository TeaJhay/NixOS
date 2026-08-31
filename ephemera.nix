{ config, lib, pkgs, inputs, ... }: {
#       ┌─────────────────────────┐
#       │       impermanence      │
#       └─────────────────────────┘

#  boot = {
  #  initrd = {
 #     availableKernelModules = [
  #      "nvme"
   #     "xhci_pci"
    #    "ahci"
     #   "usb_storage"
      #  "sd_mod"
     # ];
      #systemd.services.rollback-void = {
       # after = [ "dev-disk-by\\x2dpartlabel-disk\\x2dmain\\x2droot.device" ];
       # before = [ "sysroot.mount" ];
      #  description = "Roll back @void root subvolume to blank snapshot";
      #  path = [
      #    pkgs.btrfs-progs
      #    pkgs.coreutils
      #    pkgs.gawk
      #    pkgs.util-linux
      #  ];
      #  script = ''
      #    mkdir -p /mnt
      #    mount /dev/disk/by-partlabel/disk-main-root /mnt
      #    btrfs subvolume snapshot /mnt/@void /mnt/@snapshots/@boot-$(date +%Y-%m-%d_%H-%M-%S)
      #    for sub in $(btrfs subvolume list -o /mnt/@void 2>/dev/null | awk '{print $NF}' | sort -r); do
      #      btrfs subvolume delete "/mnt/$sub" || true
      #    done
      #    btrfs subvolume delete /mnt/@void
      #    btrfs subvolume snapshot /mnt/@void-blank /mnt/@void
      #    umount /mnt
       # '';
        #serviceConfig.Type = "oneshot";
        #unitConfig.DefaultDependencies = "no";
        #wantedBy = [ "initrd.target" ];
      #};
   # };
 # };
#       ┌─────────────────────────┐
#       │       Preservation      │
#       └─────────────────────────┘

 # boot.tmp.cleanOnBoot = true;
 # boot.tmp.useTmpfs = false;
  preservation = {
    enable = true;
    preserveAt."/persistent" = {
      # preserve system directories
      directories = [
        "/etc/nixos"
        "/etc/ssh"
        "/var/lib/flatpak"
        "/etc/secureboot"
        "/var/lib/bluetooth"
        "/var/lib/fwupd"
        "/var/lib/systemd/coredump"
        "/var/lib/systemd/rfkill"
        "/var/lib/systemd/timers"
        "/var/log"
        { directory = "/var/lib/nixos"; inInitrd = true; }
      ];
      files = [
      # enable after first boot
        { file = "/etc/machine-id"; inInitrd = true; how = "symlink"; configureParent = true; }
        { file = "/etc/ssh/ssh_host_rsa_key"; how = "symlink"; configureParent = true; }
        { file = "/etc/ssh/ssh_host_ed25519_key"; how = "symlink"; configureParent = true; }
        "/var/lib/usbguard/rules.conf"
       
       # creates a symlink on the volatile root
        # creates an empty directory on the persistent volume, i.e. /persistent/var/lib/systemd
        # does not create an empty file at the symlink's target (would require `createLinkTarget = true`)
        { file = "/var/lib/systemd/random-seed"; how = "symlink"; inInitrd = true; configureParent = true; }
      ];
      users = {
        teajhay = {
          commonMountOptions = [
          "x-gvfs-hide"
          ];
          directories = [        
            ".local/state/nvim"
            ".mozilla"
            ".thunderbird"
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

          ];
          files = [
            ".histfile"
          ];
        };
        root = {
          # specify user home when it is not `/home/${user}`
          home = "/root";
          directories = [
            { directory = ".ssh"; mode = "0700"; }
          ];
        };
      };
    };
  };
  fileSystems."/persistent/home".neededForBoot = true; # Required for impermanence persistence
  security.sudo.extraConfig = "Defaults lecture=never";
  systemd.suppressedSystemUnits = ["systemd-machine-id-commit.service"];
}
