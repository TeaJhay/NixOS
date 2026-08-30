#!/usr/bin/env bash
set -euo pipefail
LOCAL_DIR="$(cd "$(dirname "$(realpath "$0")")" && pwd)"

# Trust the local dir
sudo git config --global --add safe.directory "$LOCAL_DIR"
# Increase allowed mem/space for building
mount -o remount,size=10G,noatime /nix/.rw-store

# Disk to format
DISK="/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0"  # match disko.nix


#script for install
echo "About to WIPE and install to: $DISK"
lsblk -o NAME,SIZE,MODEL "$(readlink -f "$DISK")"
read -rp "Type YES to continue: " confirm
[[ "$confirm" == "YES" ]] || { echo "Aborted."; exit 1; }

sudo nix --show-trace --extra-experimental-features "nix-command flakes" run github:nix-community/disko/latest#disko-install -- \
  --flake .#nixos \
  --disk main "$DISK" \
  --mode format \
  --write-efi-boot-entries 


# creating snapshopt
echo "Creating pristine @void-blank snapshot..."
sudo mount -o subvol=/ /dev/disk/by-partlabel/disk-main-root /mnt
sudo btrfs subvolume snapshot -r /mnt/@void /mnt/@void-blank
sudo umount /mnt

echo "Done. Ready to reboot into the fresh install."
