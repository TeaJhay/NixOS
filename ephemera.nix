{ config, lib, pkgs, inputs, ... }: {
#       ┌─────────────────────────┐
#       │       impermanence      │
#       └─────────────────────────┘

  boot.initrd.systemd = {
    enable = true; # this enabled systemd support in stage1 - required for the below setup
    services.rollback = {
      description = "Rollback BTRFS root subvolume to a pristine state";
      wantedBy = ["initrd.target"];
      # No LUKS in this config, so no cryptsetup unit to wait on.
      # Just make sure udev has settled so the by-partlabel symlink exists.
      after = ["systemd-udev-settle.service"];
      # Before mounting the system root (/sysroot) during the early boot process
      before = ["sysroot.mount"];
      unitConfig.DefaultDependencies = "no";
      serviceConfig.Type = "oneshot";
      script = ''
        set -euo pipefail
        mkdir -p /mnt

        # Mount the BTRFS top-level (subvolid=5), not @void itself,
        # so we can see @void and @void-blank as siblings and
        # delete/recreate one from the other.
        #mount -t btrfs -o subvol=/ /dev/disk/by-partlabel/disk-main-root /mnt
        mount -o rw,subvol=/ /dev/disk/by-partlabel/disk-main-root /mnt

        # While we're tempted to just delete @void and create
        # a new snapshot from @void-blank, @void is already
        # populated at this point with a number of nested subvolumes
        # (e.g. /var/lib/portables, /var/lib/machines), which makes
        # `btrfs subvolume delete` fail on the parent.
        # So, we remove them first.
        btrfs subvolume list -o /mnt/@void |
          cut -f9 -d' ' |
          while read -r subvolume; do
            echo "deleting /$subvolume subvolume..."
            btrfs subvolume delete "/mnt/$subvolume"
          done &&
          echo "deleting /@void subvolume..." &&
          btrfs subvolume delete /mnt/@void

        echo "restoring blank /@void subvolume..."
        btrfs subvolume snapshot /mnt/@void-blank /mnt/@void

        # Once we're done rolling back to a blank snapshot,
        # we can unmount /mnt and continue on the boot process.
        umount /mnt
      '';
    };
  };
#       ┌─────────────────────────┐
#       │       Preservation      │
#       └─────────────────────────┘

  preservation = {
    enable = true;
    preserveAt."/persistent" = {
      # preserve system directories
      directories = [
        "/etc/secureboot"
        "/var/lib/bluetooth"
        "/var/lib/fwupd"
        "/var/lib/systemd/coredump"
        "/var/lib/systemd/rfkill"
        "/var/lib/systemd/timers"
        "/var/logo"
        { directory = "/var/lib/nixos"; inInitrd = true; }
      ];
      files = [
      # enable after first boot
      # { file = "/etc/machine-id"; inInitrd = true; how = "symlink"; configureParent = true; }
        { file = "/etc/ssh/ssh_host_rsa_key"; how = "symlink"; configureParent = true; }
        { file = "/etc/ssh/ssh_host_ed25519_key"; how = "symlink"; configureParent = true; }
        { file = "/var/lib/systemd/random-seed"; how = "symlink"; inInitrd = true; configureParent = true; }
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
            { directory = ".ssh"; mode = "0700"; }
            ".local/state/nvim"
            ".mozilla"
            ".thunderbird"

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
}
