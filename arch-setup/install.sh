#!/usr/bin/env bash
set -e

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd "$ROOT_DIR"

echo "Root directory: $ROOT_DIR"

# Make all scripts executable
if [ -d "$ROOT_DIR/scripts" ]; then
    echo "Setting execute permissions for scripts..."
    chmod +x "$ROOT_DIR/scripts/"*.sh
fi

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
echo " - Restore dotfiles"
echo " - Restore home files"
echo " - Move backgrounds and logos"
echo " - Mount NAS"
echo " - Configure MPD"
echo " - Install SDDM theme"
echo " - Add Wireguard Config"
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
echo " Step 5: Setting up locale"
echo "============================================"

./scripts/setup-locale.sh

echo

echo "============================================"
echo " Step 6: Restoring dotfiles"
echo "============================================"

./scripts/restore-dotfiles.sh

echo

echo "============================================"
echo " Step 7: Restoring home directory files"
echo "============================================"

./scripts/restore-home.sh

echo

echo "============================================"
echo " Step 8: Move backgrounds and logos"
echo "============================================"

./scripts/move-pictures.sh

echo

echo "============================================"
echo " Step 9: Mounting NAS"
echo "============================================"

./scripts/mount-nas.sh

echo

echo "============================================"
echo " Step 10: Automated MPD setup"
echo "============================================"

./scripts/install-mpd.sh

echo

echo "============================================"
echo " Step 11: Installing SDDM theme"
echo "============================================"

./scripts/install-sddm-theme.sh

echo

echo "============================================"
echo " Step 12: Adding Wireguard VPN"
echo "============================================"

./scripts/proton-wireguard.sh

echo

echo "============================================"
echo " Step 13: Restoring GNOME settings"
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
