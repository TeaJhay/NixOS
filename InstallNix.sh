#!/usr/bin/env bash
set -euo pipefail

# --- Config ---------------------------------------------------------------
TARGET_DIR="/etc/nixos"
TARGET_FILE="/etc/nixos/configuration.nix"
SCRIPT_NAME="$(basename "$0")"
SRC_DIR="$(cd "$(dirname "$0")" && pwd)"

# 1. Remove the specific file (only if it's a regular file or symlink, never a dir)
if [ -e "$TARGET_FILE" ] || [ -L "$TARGET_FILE" ]; then
    if [ -d "$TARGET_FILE" ] && [ ! -L "$TARGET_FILE" ]; then
        echo "Refusing to remove $TARGET_FILE: it's a directory, not a file" >&2
        exit 1
    fi
    rm -f -- "$TARGET_DIR"/*
    sudo nixos-generate-config --no-filesystems --dir "$SRC_DIR"

fi

# 2. Symlink everything from the current dir (except this script) into /etc/xx,
#    without touching anything else already in that directory
shopt -s dotglob nullglob
for item in "$SRC_DIR"/*; do
    name="$(basename "$item")"

    # skip the script itself
    [ "$name" = "$SCRIPT_NAME" ] && continue

    dest="$TARGET_DIR/$name"

    if [ -e "$dest" ] || [ -L "$dest" ]; then
        if [ -L "$dest" ]; then
            # refresh our own old symlink
            rm -f -- "$dest"
        else
            echo "Skipping $name: $dest already exists and is not a symlink" >&2
            continue
        fi
    fi

    ln -s -- "$item" "$dest"
    
    ln -s  -- "$TARGET_DIR"/hardware-configuration.nix "$SRC_DIR"


nixos-rebuild switch --flake

done

