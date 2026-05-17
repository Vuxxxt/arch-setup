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
echo " - Setup locale"
echo " - Restore GNOME settings"
echo " - Restore dotfiles"
echo " - Restore home files"
echo " - Install SDDM theme"
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
echo " Step 5: Setting up locale"
echo "============================================"

./scripts/setup-locale.sh

echo

echo "============================================"
echo " Step 6: Restoring GNOME settings"
echo "============================================"

./scripts/restore-gnome.sh

echo

echo "============================================"
echo " Step 7: Restoring dotfiles"
echo "============================================"

./scripts/restore-dotfiles.sh

echo

echo "============================================"
echo " Step 8: Restoring home directory files"
echo "============================================"

./scripts/restore-home.sh

echo
echo "============================================"
echo " Step 9: Automated MPD setup"
echo "============================================"

./scripts/install-mpd.sh

echo

echo "============================================"
echo " Step 10: Installing SDDM theme"
echo "============================================"

./scripts/install-sddm-theme.sh

echo

echo "============================================"
echo " Installation Complete"
echo "============================================"
echo

echo "You may want to:"
echo " - Log out and back in"
echo " - Reinstall GNOME extensions manually"
echo " - Verify fonts/themes"
