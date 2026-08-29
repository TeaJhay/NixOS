{ inputs, ... }: {
  imports = [ inputs.disko.nixosModules.disko ];
  disko.devices.disk.main = {
    device = "/dev/disk/by-id/nvme-CT1000T500SSD8_242649A0A283";
    type = "disk";
    content = {
      partitions = {
        ESP = {
          content = {
            format = "vfat";
            mountOptions = [ "umask=0077" ];
            mountpoint = "/boot";
            type = "filesystem";
          };
          name = "ESP";
          size = "1G";
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
              "/@snapshots" = {
                mountOptions = [ "subvol=@snapshots" ];
                mountpoint = "/snapshots";
              };
              "/@home" = {
                mountOptions = [ 
                  "subvol=@home"
                  "compress=zstd"
                ];
                mountpoint = "/persistent/home";
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
          size = "32G";
        };
      };
      type = "gpt";
    };
  };
  fileSystems."/nix".neededForBoot = true;
  fileSystems."/persistent".neededForBoot = true;
}
