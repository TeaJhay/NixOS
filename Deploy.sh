##!/usr/bin/env bash
#set -euo pipefail
#LOCAL_DIR="$(cd "$(dirname "$(realpath "$0")")" && pwd)"
#
## Trust the local dir
#sudo git config --global --add safe.directory "$LOCAL_DIR"
## Increase allowed mem/space for building
#mount -o remount,size=10G,noatime /nix/.rw-store
#
## Disk to format
#DISK="/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0"  # match disko.nix
#
#
##script for install
#echo "About to WIPE and install to: $DISK"
#lsblk -o NAME,SIZE,MODEL "$(readlink -f "$DISK")"
#read -rp "Type YES to continue: " confirm
#[[ "$confirm" == "YES" ]] || { echo "Aborted."; exit 1; }
#
#sudo nix --show-trace --extra-experimental-features "nix-command flakes" run github:nix-community/disko/latest#disko-install -- \
#  --flake .#nixos \
#  --disk main "$DISK" \
#  --mode format \
#  --write-efi-boot-entries 
#
#
## creating snapshopt
#echo "Creating pristine @void-blank snapshot..."
#sudo mount -o subvol=/ /dev/disk/by-partlabel/disk-main-root /mnt
#sudo btrfs subvolume snapshot -r /mnt/@void /mnt/@void-blank
#sudo umount /mnt
#
#echo "Done. Ready to reboot into the fresh install."


# Because Disko hasn't decided to resolve an issue that occurs when you don't have enough tmpfs memory or storage, I'll two phase it. However I want 1 phase at some point.

#!/usr/bin/env bash
set -euo pipefail

LOCAL_DIR="$(cd "$(dirname "$(realpath "$0")")" && pwd)"
sudo git config --global --add safe.directory "$LOCAL_DIR"

DISK="/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0"  # match disko.nix

echo "About to WIPE and install to: $DISK"
lsblk -o NAME,SIZE,MODEL "$(readlink -f "$DISK")"
read -rp "Type YES to continue: " confirm
[[ "$confirm" == "YES" ]] || { echo "Aborted."; exit 1; }

echo "== Phase 1: partition + format only =="
sudo nix --extra-experimental-features "nix-command flakes" run \
  --refresh \
  github:nix-community/disko/latest -- \
  --flake "$LOCAL_DIR#nixos" \
  --mode destroy,format,mount \
#  --disk main "$DISK" \

echo "== Enabling swap for the build step =="
sudo swapon /dev/disk/by-partlabel/disk-main-swap
free -h

echo "== Phase 2: build + install (swap already active) =="
sudo nix --extra-experimental-features "nix-command flakes" run \
  github:nix-community/disko/latest#disko-install -- \
  --flake "$LOCAL_DIR#nixos" \
  --mode mount \
  --disk main "$DISK" \
  --write-efi-boot-entries

echo "== Creating pristine @void-blank snapshot =="
sudo mount -o subvol=/ /dev/disk/by-partlabel/disk-main-root /mnt
sudo btrfs subvolume snapshot -r /mnt/@void /mnt/@void-blank
sudo umount /mnt

echo "Done. Run 'sudo reboot' when ready."
