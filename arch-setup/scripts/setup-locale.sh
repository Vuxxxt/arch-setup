#!/usr/bin/env bash
set -e

echo "============================================"
echo " Setting up system locale"
echo "============================================"

# Ensure locale file exists
if [ ! -f /etc/locale.gen ]; then
    echo "ERROR: /etc/locale.gen not found"
    exit 1
fi

# Enable US English + Japanese (dual setup)
sudo sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
sudo sed -i 's/^#ja_JP.UTF-8 UTF-8/ja_JP.UTF-8 UTF-8/' /etc/locale.gen

echo "Generating locales..."
sudo locale-gen

echo "Setting system language to US English..."
sudo localectl set-locale LANG=en_US.UTF-8

echo "Locale setup complete"
