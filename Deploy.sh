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
[[ "${confirm,,}" == "yes" ]] || { echo "Aborted."; exit 1; }

echo "== Phase 1: partition + format only =="
sudo nix --extra-experimental-features "nix-command flakes" run \
  --refresh \
  github:nix-community/disko/latest -- \
  --flake "$LOCAL_DIR#nixos" \
  --mode destroy,format,mount \
#  --disk main "$DISK" \

echo "== Enabling swap + raising live-session store size =="
SWAP_PART=$(lsblk -no PATH,FSTYPE "$DISK" | awk '$2=="swap"{print $1; exit}')

if [[ -z "$SWAP_PART" ]]; then
  echo "No swap partition found on $DISK — skipping swapon"
elif swapon --show | grep -q "$SWAP_PART"; then
  echo "Swap already active on $SWAP_PART"
else
  sudo swapon "$SWAP_PART"
fi

sudo mount -o remount,size=20G /nix/.rw-store
free -h



echo "Made it through the disko and swap. Proceed?"
read -rp "Type YES to continue: " confirm
[[ "${confirm,,}" == "yes" ]] || { echo "Aborted."; exit 1; }


echo "== Phase 2: build + install (swap already active) =="

sudo nix --extra-experimental-features "nix-command flakes" --accept-flake-config --show-trace run \
  github:nix-community/disko/latest#disko-install -- \
  --flake "$LOCAL_DIR#nixos" \
#  --option max-jobs 2 \
  --option store "local?root=/mnt" \
  --mode mount \
  --disk main "$DISK" \
  --write-efi-boot-entries

echo "== Creating pristine @void-blank snapshot =="
sudo mount -o subvol=/ /dev/disk/by-partlabel/disk-main-root /mnt
sudo btrfs subvolume snapshot -r /mnt/@void /mnt/@void-blank
sudo umount /mnt

echo "Done. Run 'sudo reboot' when ready."
