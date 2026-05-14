#!/bin/bash
# Build the AkulaOS installer ISO.
# Requires: archiso (sudo pacman -S archiso)
# Must run as root.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUT="$SCRIPT_DIR/../build/iso"

[[ $EUID -eq 0 ]] \
    || { echo "Run as root: sudo bash iso/build.sh"; exit 1; }

pacman -S --needed --noconfirm archiso grub

mkdir -p "$OUT"
mkarchiso -v -o "$OUT" "$SCRIPT_DIR"

echo ""
echo "ISO ready: $(ls "$OUT"/akula-os-*.iso 2>/dev/null | tail -1)"
echo "Write to USB: sudo dd if=<path>.iso of=/dev/sdX bs=4M status=progress oflag=sync"
