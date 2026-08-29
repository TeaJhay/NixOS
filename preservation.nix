#       ┌─────────────────────────┐
#       │       Preservation      │
#       └─────────────────────────┘

{ config, lib, pkgs, ...}:

{
  preservation = {
    # the module doesn't do anything unless it is enabled
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

      # preserve system files
      files = [
        { file = "/etc/machine-id"; inInitrd = true; how = "symlink"; configureParent = true; }
        { file = "/etc/ssh/ssh_host_rsa_key"; how = "symlink"; configureParent = true; }
        { file = "/etc/ssh/ssh_host_ed25519_key"; how = "symlink"; configureParent = true; }

        # creates a symlink on the volatile root
        # creates an empty directory on the persistent volume, i.e. /persistent/var/lib/systemd
        # does not create an empty file at the symlink's target (would require `createLinkTarget = true`)
        { file = "/var/lib/systemd/random-seed"; how = "symlink"; inInitrd = true; configureParent = true; }
      ];
    }
  }
}
