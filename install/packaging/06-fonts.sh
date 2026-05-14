#!/bin/bash
set -euo pipefail

info "Fonts"

pkg_install \
    ttf-jetbrains-mono noto-fonts noto-fonts-emoji fontconfig

# AUR: Inter (UI sans), PT Sans + PT Mono (Cyrillic), Bebas Neue (display/branding)
aur_install \
    inter-font ttf-paratype ttf-bebas-neue

ok "Fonts installed"
