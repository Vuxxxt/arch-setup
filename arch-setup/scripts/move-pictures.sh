#!/usr/bin/env bash

set -euo pipefail

echo "======================================"
echo "Copy Pictures Folder Contents"
echo "Portable Arch Setup Script"
echo "======================================"

# Detect current user home automatically
HOME_DIR="${HOME}"

SRC="${HOME_DIR}/arch-setup/configs/pictures"
DEST="${HOME_DIR}/Pictures"

echo
echo "Source:      $SRC"
echo "Destination: $DEST"

if [[ ! -d "$SRC" ]]; then
    echo "ERROR: Source folder does not exist:"
    echo "$SRC"
    exit 1
fi

mkdir -p "$DEST"

echo
echo "Copying files..."

# Include hidden files safely
shopt -s dotglob nullglob

for item in "$SRC"/*; do
    echo "Copying: $(basename "$item")"
    cp -r -n "$item" "$DEST/"
done

echo
echo "Done."
echo "Files copied to: $DEST"
