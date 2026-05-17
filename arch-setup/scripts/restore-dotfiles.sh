#!/usr/bin/env bash
set -e

SOURCE_DIR="configs/dotfiles"
TARGET_DIR="$HOME/.config"

mkdir -p "$TARGET_DIR"

echo "Restoring dotfiles..."

for dir in "$SOURCE_DIR"/*; do
    [ -d "$dir" ] || continue

    name=$(basename "$dir")

    echo
    echo ">>> Restoring $name"

    target="$TARGET_DIR/$name"

    # Remove existing config
    if [ -e "$target" ]; then
        echo "Removing existing config: $target"
        rm -rf "$target"
    fi

    # Copy new config
    cp -r "$dir" "$target"

    echo "Installed: $target"
done

echo

echo "Dotfiles restored successfully."
