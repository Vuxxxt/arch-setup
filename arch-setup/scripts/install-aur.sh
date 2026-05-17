#!/usr/bin/env bash
set -e

echo "Reading AUR package list..."
echo

packages=()

while read -r pkg; do
    [[ -z "$pkg" || "$pkg" == \#* ]] && continue
    packages+=("$pkg")
done < packages/aur.txt

echo "The following AUR packages will be installed:"
echo "--------------------------------------------"

for pkg in "${packages[@]}"; do
    echo " - $pkg"
done

echo "--------------------------------------------"
echo

read -rp "Proceed with AUR installation? (y/N): " confirm

if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 0
fi

echo
echo "Installing AUR packages..."

failed=()
success=()

for pkg in "${packages[@]}"; do
    echo
    echo ">>> Installing $pkg"

    if yay -S --needed --noconfirm "$pkg"; then
        success+=("$pkg")
    else
        echo "!!! Failed to install $pkg"
        failed+=("$pkg")
    fi
done

echo
echo "============================================"
echo "AUR install summary"
echo "============================================"

echo "Successful:"
for pkg in "${success[@]}"; do
    echo "  ✔ $pkg"
done

echo
echo "Failed:"
for pkg in "${failed[@]}"; do
    echo "  ✖ $pkg"
done

echo
echo "Done."
