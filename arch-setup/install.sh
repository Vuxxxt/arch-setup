#!/usr/bin/env bash
set -e

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd "$ROOT_DIR"

clear

echo "============================================"
echo " Arch Linux Full Restore Installer"
echo "============================================"
echo

echo "This installer will:"
echo " - Install yay if missing"
echo " - Install pacman packages"
echo " - Install AUR packages"
echo " - Install flatpak applications"
echo " - Restore GNOME settings"
echo

read -rp "Proceed? (y/N): " confirm

if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 0
fi

echo

echo "============================================"
echo " Step 1: Installing yay"
echo "============================================"

./scripts/install-yay.sh

echo

echo "============================================"
echo " Step 2: Installing pacman packages"
echo "============================================"

./scripts/install-pacman.sh

echo

echo "============================================"
echo " Step 3: Installing AUR packages"
echo "============================================"

./scripts/install-aur.sh

echo

echo "============================================"
echo " Step 4: Installing Flatpaks"
echo "============================================"

./scripts/install-flatpak.sh

echo

echo "============================================"
echo " Step 5: Restoring GNOME settings"
echo "============================================"

./scripts/restore-gnome.sh

echo

echo "============================================"
echo " Installation Complete"
echo "============================================"
echo

echo "You may want to:"
echo " - Log out and back in"
echo " - Reinstall GNOME extensions manually"
echo " - Verify fonts/themes"
echo
