{ config, lib, pkgs, inputs, ... }: {

#       ┌─────────────────────────┐
#       │       impermanence      │
#       └─────────────────────────┘
  
  boot.initrd.postResumeCommands = lib.mkAfter ''
    mkdir /btrfs_tmp
    mount /dev/disk/by-partlabel/root /btrfs_tmp

    # Delete everything inside @void safely by re-creating it
    if [ -e /btrfs_tmp/@void ]; then
        echo "Wiping @void root subvolume..."
        btrfs subvolume delete /btrfs_tmp/@void
    fi
    
    echo "Restoring pristine @void subvolume..."
    btrfs subvolume create /btrfs_tmp/@void

    umount /btrfs_tmp
  '';
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
        "/var/log"
        { directory = "/var/lib/nixos"; inInitrd = true; }
      ];
      files = [
        { file = "/etc/machine-id"; inInitrd = true; how = "symlink"; configureParent = true; }
        { file = "/etc/ssh/ssh_host_rsa_key"; how = "symlink"; configureParent = true; }
        { file = "/etc/ssh/ssh_host_ed25519_key"; how = "symlink"; configureParent = true; }
        { file = "/var/lib/systemd/random-seed"; how = "symlink"; inInitrd = true; configureParent = true; }
      ];
    };
  };
}
