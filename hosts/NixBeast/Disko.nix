{ inputs, ... }: {
  imports = [ inputs.disko.nixosModules.disko ];
  # Enable supported filesystems
  boot.supportedFilesystems = [
    "btrfs"
    "nfs"
  ];
  # Swap
  zramSwap = {
    enable = true;
    algorithm = "lz4";
    memoryPercent = 150;
  };
  # Partitions
  disko.devices.disk.main = {
    content = {
      partitions = {
        esp = {
          content = {
            format = "vfat";
            mountOptions = [ "umask=0077" ];
            mountpoint = "/boot";
            type = "filesystem";
          };
          name = "ESP";
          priority = 1;
          size = "5G";
          type = "EF00";
        };
        root = {
          content = {
            extraArgs = [ "-f" ];
            subvolumes = {
              "/@nix" = {
                mountOptions = [
                  "subvol=@nix"
                  "compress=zstd"
                  "noatime"
                ];
                mountpoint = "/nix";
              };
              "/@persistent" = {
                mountOptions = [
                  "subvol=@persistent"
                  "compress=zstd"
                  "noatime"
                ];
                mountpoint = "/persistent";
              };
              "/@home" = {
                mountOptions = [
                  "subvol=@home"
                  "compress=zstd"
                  "noatime"
                ];
                mountpoint = "/persistent/home";
              };
              "/@snapshots" = {
                mountOptions = [ "subvol=@snapshots" ];
                mountpoint = "/snapshots";
              };
              "/@void" = {
                mountOptions = [
                  "subvol=@void"
                  "compress=zstd"
                  "noatime"
                ];
                mountpoint = "/";
              };
              "/@games" = {
                mountOptions = [
                  "subvol=@games"
                  "compress=zstd"
                  "noatime"
                  "discard=async"
                ];
                mountpoint = "/games";
              };
              "/@void-blank" = {
                mountOptions = [ "subvol=@void-blank" ];
              };
            };
            type = "btrfs";
          };
          name = "root";
          priority = 3;
          size = "100%";
        };
        #swap = {
        #  content = {
        #    resumeDevice = true;
        #    type = "swap";
        #  };
        #  name = "swap";
        #  priority = 2;
        #  size = "32G";
        #};
      };
      type = "gpt";
    };
    device = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0";
    #    device = "/dev/disk/by-id/nvme-CT1000T500SSD8_242649A0A283";
    type = "disk";
  };

  services.rpcbind.enable = true;
  fileSystems = {
    "/nix".neededForBoot = true;
    "/persistent".neededForBoot = true;

    #       ┌─────────────────────────┐
    #       │   Local (ext4) Drives   │
    #       └─────────────────────────┘

    "/mnt/Linux Games" = {
      device = "/dev/disk/by-uuid/dbf5efdd-db81-4e78-b634-b1104ff4d8fb";
      fsType = "ext4";
      options = [
        "defaults"
        "noatime"
        "acl"
        "x-systemd.automount"
        "noauto"
      ];
    };

    #       ┌─────────────────────────┐
    #       │  Network (NFS) Mounts   │
    #       └─────────────────────────┘

    "/mnt/Storage" = {
      device = "10.0.1.200:/mnt/Jormungandr/Desktop/Documents";
      fsType = "nfs";
      options = [
        "soft"
        "rw"
        "x-systemd.automount"
        "noauto"
      ];
    };

    "/home/teajhay/Downloads" = {
      device = "10.0.1.200:/mnt/Jormungandr/Desktop/Documents/Downloads";
      fsType = "nfs";
      options = [
        "soft"
        "rw"
        "x-systemd.automount"
        "noauto"
      ];
    };

    "/home/teajhay/Documents" = {
      device = "10.0.1.200:/mnt/Jormungandr/Desktop/Documents/Documents";
      fsType = "nfs";
      options = [
        "soft"
        "rw"
        "x-systemd.automount"
        "noauto"
      ];
    };

    "/home/teajhay/Pictures" = {
      device = "10.0.1.200:/mnt/Jormungandr/Desktop/Pictures";
      fsType = "nfs";
      options = [
        "soft"
        "rw"
        "x-systemd.automount"
        "noauto"
      ];
    };
  };

}
