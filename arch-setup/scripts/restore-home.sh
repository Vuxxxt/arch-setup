#!/usr/bin/env bash
set -e

SOURCE_DIR="configs/home"
TARGET_DIR="$HOME"

echo "Checking for special directory renames..."

# Rename themes → .themes (portable + safe)
if [ -d "$SOURCE_DIR/themes" ] && [ ! -d "$SOURCE_DIR/.themes" ]; then
    echo "Renaming themes → .themes"
    mv "$SOURCE_DIR/themes" "$SOURCE_DIR/.themes"
fi

mkdir -p "$TARGET_DIR"

echo
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

# Auto-chmod scripts folder
SCRIPTS_DIR="$TARGET_DIR/scripts"
if [ -d "$SCRIPTS_DIR" ]; then
    echo
    echo "Setting execute permissions for all scripts in $SCRIPTS_DIR..."
    chmod -R +x "$SCRIPTS_DIR"
fi

echo
echo "Home directory restore complete."
