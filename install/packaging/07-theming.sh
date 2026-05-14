#!/bin/bash
set -euo pipefail

info "Theming"

pkg_install \
    gnome-themes-extra yaru-icon-theme gnome-disk-utility \
    qt5-wayland qt6-wayland

# AUR: Kvantum Qt5 theme engine
aur_install \
    kvantum-qt5

ok "Theming installed"
