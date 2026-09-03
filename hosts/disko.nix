{ inputs, ... }: {
  imports = [ inputs.disko.nixosModules.disko ];
    # Enable supported filesystems
  boot.supportedFilesystems = [ "btrfs" ];
# partitions
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
        swap = {
          content = {
            resumeDevice = true;
            type = "swap";
          };
          name = "swap";
          priority = 2;
          size = "12G";
        };
      };
      type = "gpt";
    };
    device = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0";
#    device = "/dev/disk/by-id/nvme-CT1000T500SSD8_242649A0A283";
    type = "disk";
  };
  fileSystems."/nix".neededForBoot = true;
  fileSystems."/persistent".neededForBoot = true;
}
