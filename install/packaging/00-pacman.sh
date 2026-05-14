#!/bin/bash
set -euo pipefail

info "Pacman setup"

# Refresh the keyring so all subsequent package installs pass signature checks
sudo pacman-key --init
sudo pacman-key --populate archlinux

# Parallel downloads: speed up multi-package stages
sudo sed -i 's/^#\?ParallelDownloads\s*=.*/ParallelDownloads = 5/' \
    /etc/pacman.conf

# Enable multilib (some audio and graphics libraries need it)
sudo sed -i '/^\[multilib\]/{n;s/^#Include/Include/}' /etc/pacman.conf

# Full system update before touching anything — avoid partial-upgrade breakage
sudo pacman -Syu --noconfirm

ok "Pacman setup complete"
