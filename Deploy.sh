#!/usr/bin/env bash
set -euo pipefail
export NIX_CONFIG="experimental-features = nix-command flakes"

DISK="/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0"  # match disko.nix

echo "About to WIPE and install to: $DISK"
lsblk -o NAME,SIZE,MODEL "$(readlink -f "$DISK")"
read -rp "Type YES to continue: " confirm
[[ "$confirm" == "YES" ]] || { echo "Aborted."; exit 1; }

sudo nix --extra-experimental-features "nix-command flakes" run github:nix-community/disko/latest#disko-install -- \
  --flake .#nixos \
  --write-efi-boot-entries \
  --no-reboot

echo "Creating pristine @void-blank snapshot..."
sudo mount -o subvol=/ /dev/disk/by-partlabel/disk-main-root /mnt
sudo btrfs subvolume snapshot -r /mnt/@void /mnt/@void-blank
sudo umount /mnt

echo "Done. Ready to reboot into the fresh install."
