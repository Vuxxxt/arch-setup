#!/usr/bin/env bash
set -e

if command -v yay &>/dev/null; then
    echo "yay is already installed."
    exit 0
fi

echo "Installing yay prerequisites..."
sudo pacman -S --needed base-devel git

echo "Cloning yay..."
tmpdir=$(mktemp -d)
git clone https://aur.archlinux.org/yay.git "$tmpdir/yay"

cd "$tmpdir/yay"
makepkg -si

echo "Cleaning up..."
rm -rf "$tmpdir"

echo "yay installed successfully."
