#!/usr/bin/env bash
set -e

SOURCE_DIR="configs/home"
TARGET_DIR="$HOME"

mkdir -p "$TARGET_DIR"

echo "Restoring home directory files..."

for item in "$SOURCE_DIR"/* "$SOURCE_DIR"/.*; do
    name=$(basename "$item")

    # Skip invalid entries
    [[ "$name" == "." || "$name" == ".." ]] && continue
    [ -e "$item" ] || continue

    target="$TARGET_DIR/$name"

    echo
    echo ">>> Restoring $name"

    # Remove existing file/folder
    if [ -e "$target" ]; then
        echo "Removing existing: $target"
        rm -rf "$target"
    fi

    cp -r "$item" "$target"

    echo "Installed: $target"
done

echo

echo "Home directory restore complete."
