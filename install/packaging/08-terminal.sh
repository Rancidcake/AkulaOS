#!/bin/bash
set -euo pipefail

info "Terminal, shell, and utilities"

pkg_install \
    foot tmux starship \
    nano helix \
    btop fastfetch fzf ripgrep bat eza fd \
    zoxide lazygit dust plocate tealdeer \
    imagemagick imv mpv evince \
    github-cli mise

# AUR: xdg-terminal-exec (default terminal abstraction)
aur_install \
    xdg-terminal-exec

ok "Terminal and utilities installed"
