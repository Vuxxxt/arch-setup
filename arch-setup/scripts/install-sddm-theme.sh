#!/usr/bin/env bash
set -e

echo
echo "=============================="
echo "SDDM Astronaut Theme"
echo "=============================="

THEME_NAME="sddm-astronaut-theme"
THEME_DIR="/usr/share/sddm/themes/$THEME_NAME"
CONFIG_DIR="$(pwd)/configs/sddm"

# ----------------------------------------------------
# 1. CLEAN OLD SYSTEM INSTALLS
# ----------------------------------------------------
echo "Cleaning old SDDM theme installs..."

sudo rm -rf /usr/share/sddm/themes/sddm_astronaut_theme*
sudo rm -rf /usr/share/sddm/themes/sddm-astronaut-theme*

# ----------------------------------------------------
# 2. INSTALL THEME
# ----------------------------------------------------
echo "Running Astronaut theme installer..."

bash -c "$(curl -fsSL https://raw.githubusercontent.com/keyitdev/sddm-astronaut-theme/master/setup.sh)"

# ----------------------------------------------------
# 3. RESOLVE INSTALL PATH
# ----------------------------------------------------
if [ ! -d "$THEME_DIR" ]; then
    THEME_DIR=$(find /usr/share/sddm/themes -maxdepth 1 -type d -name "*astronaut*" | head -n 1)

    if [ -z "$THEME_DIR" ]; then
        echo "ERROR: Theme installation failed."
        exit 1
    fi
fi

echo "Using theme directory: $THEME_DIR"

# ----------------------------------------------------
# 4. APPLY CUSTOM FILES
# ----------------------------------------------------
echo "Applying custom SDDM files..."

sudo cp -f "$CONFIG_DIR/hollowknight.conf" "$THEME_DIR/Themes/" 2>/dev/null || true
sudo cp -f "$CONFIG_DIR/hollow_knight.png" "$THEME_DIR/Backgrounds/" 2>/dev/null || true
sudo cp -f "$CONFIG_DIR/metadata.desktop" "$THEME_DIR/" 2>/dev/null || true

# ----------------------------------------------------
# 5. CLEAN HOME DIRECTORY
# ----------------------------------------------------
echo "Cleaning leftover installer files in HOME..."

rm -rf "$HOME/sddm-astronaut-theme"
rm -rf "$HOME/sddm_astronaut_theme"

# ----------------------------------------------------
# 6. DONE
# ----------------------------------------------------
echo
echo "Theme folders:"
ls /usr/share/sddm/themes | grep -i astronaut || true

echo
echo "✅ SDDM Astronaut theme installed successfully"
