{ config, lib, pkgs, ... }:

{
  # Needed for NFS mounts
  boot.supportedFilesystems = [ "nfs" ];
  services.rpcbind.enable = true;

  # Uncomment if/when you switch any mounts to CIFS/SMB
  # environment.systemPackages = [ pkgs.cifs-utils ];

  fileSystems = {
    # --- Local ext4 drives ---
    "/home/teejay/Games" = {
      device = "/dev/disk/by-uuid/cac8f1d0-0418-4eb9-a5b9-2b6ecf1adfd7";
      fsType = "ext4";
      options = [ "defaults" "noatime" "acl" ];
    };

    "/media/Linux Games" = {
      device = "/dev/disk/by-uuid/dbf5efdd-db81-4e78-b634-b1104ff4d8fb";
      fsType = "ext4";
      options = [ "defaults" "noatime" "acl" ];
    };

    # --- Network (NFS) mounts ---
    "/mnt/Storage" = {
      device = "10.0.1.200:/mnt/Jormungandr/Desktop/Documents";
      fsType = "nfs";
      options = [ "soft" "noatime" "rw" "x-systemd.automount" "noauto" ];
    };

    "/home/teejay/Downloads" = {
      device = "10.0.1.200:/mnt/Jormungandr/Desktop/Documents/Downloads";
      fsType = "nfs";
      options = [ "soft" "noatime" "rw" "x-systemd.automount" "noauto" ];
    };

    "/home/teejay/Documents" = {
      device = "10.0.1.200:/mnt/Jormungandr/Desktop/Documents/Documents";
      fsType = "nfs";
      options = [ "soft" "noatime" "rw" "x-systemd.automount" "noauto" ];
    };

    "/home/teejay/Pictures" = {
      device = "10.0.1.200:/mnt/Jormungandr/Desktop/Pictures";
      fsType = "nfs";
      options = [ "soft" "noatime" "rw" "x-systemd.automount" "noauto" ];
    };
  };
}
