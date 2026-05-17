#!/usr/bin/env bash

set -euo pipefail

echo "======================================"
echo "Proton VPN WireGuard (GNOME / NM)"
echo "Idempotent Clean Setup"
echo "======================================"

# ---- path resolution ----
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SOURCE_CONF="${REPO_ROOT}/additions/Linux-UK-299.conf"
# -------------------------

VPN_NAME="Linux-UK-299"

echo
echo "Using config:"
echo "  $SOURCE_CONF"

if [[ ! -f "$SOURCE_CONF" ]]; then
    echo "ERROR: config not found"
    exit 1
fi

echo
echo "Checking for existing WireGuard VPN profiles..."

UUIDS=$(nmcli -t -f UUID,NAME,TYPE connection show \
    | awk -F: -v name="$VPN_NAME" '$2 == name && $3 == "wireguard" {print $1}')

if [[ -n "$UUIDS" ]]; then
    echo "Removing existing VPN profile(s)..."

    for uuid in $UUIDS; do
        echo "Deleting UUID: $uuid"
        nmcli connection delete uuid "$uuid"
    done
else
    echo "No existing VPN profiles found."
fi

echo
echo "Importing WireGuard into NetworkManager..."

nmcli connection import type wireguard file "$SOURCE_CONF"

echo
echo "Configuring autoconnect..."

nmcli connection modify "$VPN_NAME" connection.autoconnect yes
nmcli connection modify "$VPN_NAME" connection.autoconnect-priority 100
nmcli connection modify "$VPN_NAME" connection.autoconnect-retries 0

echo
echo "Done."
echo "VPN profile: $VPN_NAME"
echo "Auto-connect: enabled"
echo "Managed by: NetworkManager (GNOME integration)"
