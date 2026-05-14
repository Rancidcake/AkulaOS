#!/bin/bash
set -euo pipefail

info "AUR helper (yay)"

if cmd_exists yay; then
    ok "yay already installed, skipping"
    return 0
fi

# base-devel and git are prerequisites for makepkg
sudo pacman -S --needed --noconfirm git base-devel

(
    tmp=$(mktemp -d)
    trap 'rm -rf "$tmp"' EXIT
    git clone https://aur.archlinux.org/yay.git "$tmp/yay"
    cd "$tmp/yay"
    makepkg -si --noconfirm
)

yay --version &>/dev/null || fail "yay install failed — AUR may be unreachable."
ok "yay installed"
