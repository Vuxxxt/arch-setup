#!/usr/bin/env bash
set -e

echo "============================================"
echo " Step: Automated MPD setup"
echo "============================================"

# Directories
mkdir -p "$HOME/.config/mpd" \
         "$HOME/.config/mpd/playlists" \
         "$HOME/.cache/mpd" \
         "$HOME/.local/share/mpd" \
         "$HOME/Music"

# Config file
if [ -f "configs/mpd/mpd.conf" ]; then
    echo "Copying MPD config..."
    cp configs/mpd/mpd.conf "$HOME/.config/mpd/mpd.conf"
fi

# Log file
touch "$HOME/.cache/mpd/log"
chmod 644 "$HOME/.cache/mpd/log"

# Fix ownership
chown -R "$USER:$USER" "$HOME/.config/mpd" "$HOME/.cache/mpd" "$HOME/.local/share/mpd" "$HOME/Music"

# Reload systemd user services and start MPD
systemctl --user daemon-reload
systemctl --user enable mpd
systemctl --user restart mpd

# Update MPD library
mpc update || true

echo "MPD setup complete."
