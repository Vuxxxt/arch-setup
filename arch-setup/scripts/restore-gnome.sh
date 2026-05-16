#!/usr/bin/env bash
set -e

echo "Restoring GNOME settings..."

# Restore dconf settings
if [ -f configs/gnome-dconf.ini ]; then
    dconf load / < configs/gnome-dconf.ini
fi

echo "Done. You may need to log out/restart GNOME Shell."
