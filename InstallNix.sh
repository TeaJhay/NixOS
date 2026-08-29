#!/usr/bin/env bash
set -euo pipefail

# --- Config ---------------------------------------------------------------
FLAKE_DIR="/tmp/nixos"
FLAKE_TARGET="${FLAKE_DIR}#nixos"
ROOT_PARTLABEL="/dev/disk/by-partlabel/disk-main-root"
SWAP_PARTLABEL="/dev/disk/by-partlabel/disk-main-swap"
MOUNTPOINT="/mnt"
# ---------------------------------------------------------------------------

echo ">>> Allowing root to trust the flake repo (avoids libgit2 ownership check failures under sudo)..."
sudo git config --global --add safe.directory "${FLAKE_DIR}"

echo ">>> Generating hardware-configuration.nix for this machine..."
sudo nixos-generate-config --no-filesystems --dir /tmp/hwconf-scratch
sudo cp /tmp/hwconf-scratch/hardware-configuration.nix "${FLAKE_DIR}/hardware-configuration.nix"
sudo chown "$(id -u):$(id -g)" "${FLAKE_DIR}/hardware-configuration.nix"
sudo rm -rf /tmp/hwconf-scratch

echo ">>> Staging hardware-configuration.nix with git (required for flakes to see it)..."
git -C "${FLAKE_DIR}" add hardware-configuration.nix

echo ">>> Formatting and mounting disk via disko..."
sudo nix --extra-experimental-features "nix-command flakes" \
  run 'github:nix-community/disko/latest' -- \
  --mode disko \
  --flake "${FLAKE_TARGET}" \
  --root-mountpoint "${MOUNTPOINT}"

echo ">>> Activating swap for extra headroom during the build..."
sudo swapon "${SWAP_PARTLABEL}"

echo ">>> Redirecting build tmp dir onto the target SSD (avoids filling the live ISO's tmpfs)..."
sudo mkdir -p "${MOUNTPOINT}/tmp-install"
export TMPDIR="${MOUNTPOINT}/tmp-install"

echo ">>> Running nixos-install (TMPDIR=${TMPDIR})..."
sudo TMPDIR="${TMPDIR}" nixos-install --flake "${FLAKE_TARGET}" --root "${MOUNTPOINT}"

echo ">>> Install finished. Cleaning up build tmp dir..."
sudo rm -rf "${MOUNTPOINT}/tmp-install"

echo ">>> Taking blank @void snapshot for impermanence rollback..."
sudo mount -o subvol=/ "${ROOT_PARTLABEL}" "${MOUNTPOINT}"
sudo btrfs subvolume snapshot "${MOUNTPOINT}/@void" "${MOUNTPOINT}/@void-blank"
sudo umount "${MOUNTPOINT}"

echo ">>> Deactivating swap..."
sudo swapoff "${SWAP_PARTLABEL}"

echo ">>> Done. @void-blank created. Reboot when ready:"
echo "    sudo reboot"
