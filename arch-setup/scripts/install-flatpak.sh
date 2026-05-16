#!/usr/bin/env bash
set -e

echo "Reading Flatpak package list..."
echo

apps=()

while read -r app; do
    [[ -z "$app" || "$app" == \#* ]] && continue
    apps+=("$app")
done < packages/flatpak.txt

echo "The following Flatpaks will be installed:"
echo "----------------------------------------"

for app in "${apps[@]}"; do
    echo " - $app"
done

echo "----------------------------------------"
echo

read -rp "Proceed with installation? (y/N): " confirm

if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 0
fi

echo
echo "Installing Flatpaks..."

for app in "${apps[@]}"; do
    echo "Installing $app"
    flatpak install -y flathub "$app"
done
