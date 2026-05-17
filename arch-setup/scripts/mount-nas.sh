#!/usr/bin/env bash

set -euo pipefail

########################################
# Vuxt NAS SMB Auto-Mount Setup
# Arch Linux + GNOME
########################################

NAS_IP="192.168.1.92"
SHARE_NAME="Vuxt"

MOUNT_POINT="/mnt/Vuxt-NAS"

LINUX_USER="vuxt"

CREDENTIALS_FILE="/etc/samba/credentials-vuxt-nas"

########################################

echo "==> Installing required packages..."

sudo pacman -Sy --needed --noconfirm cifs-utils

echo "==> Creating mount point..."

sudo mkdir -p "$MOUNT_POINT"

echo "==> Enter NAS credentials"

read -rp "SMB Username: " SMB_USERNAME
read -rsp "SMB Password: " SMB_PASSWORD
echo

echo "==> Creating secure credentials file..."

sudo mkdir -p /etc/samba

sudo tee "$CREDENTIALS_FILE" >/dev/null <<EOF
username=$SMB_USERNAME
password=$SMB_PASSWORD
EOF

sudo chmod 600 "$CREDENTIALS_FILE"

echo "==> Configuring /etc/fstab..."

FSTAB_ENTRY="//$NAS_IP/$SHARE_NAME $MOUNT_POINT cifs credentials=$CREDENTIALS_FILE,uid=$(id -u "$LINUX_USER"),gid=$(id -g "$LINUX_USER"),iocharset=utf8,nofail,_netdev,x-systemd.automount,x-systemd.idle-timeout=60,file_mode=0664,dir_mode=0775 0 0"

if grep -qs "$MOUNT_POINT" /etc/fstab; then
    echo "Mount already exists in fstab — skipping."
else
    echo "$FSTAB_ENTRY" | sudo tee -a /etc/fstab >/dev/null
fi

echo "==> Reloading systemd..."

sudo systemctl daemon-reload

echo "==> Testing mount..."

sudo mount -a

if mountpoint -q "$MOUNT_POINT"; then
    echo
    echo "========================================"
    echo "NAS successfully mounted!"
    echo "Location:"
    echo "  $MOUNT_POINT"
    echo "========================================"
else
    echo
    echo "Mount test completed."
    echo "The share will auto-mount on first access."
    echo
    echo "Try:"
    echo "  ls $MOUNT_POINT"
fi
