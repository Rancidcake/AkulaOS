#!/bin/bash
set -euo pipefail

info "Wayland + Sway"

pkg_install \
    sway swaybg swayidle swaylock uwsm \
    xdg-desktop-portal xdg-desktop-portal-wlr xdg-desktop-portal-gtk \
    waybar mako wofi \
    grim slurp wl-clipboard brightnessctl

ok "Wayland + Sway installed"
