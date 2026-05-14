#!/bin/bash
set -euo pipefail

AKULA_USER=$(whoami)

# ── TTY1 autologin ────────────────────────────────────────────────────────────

info "TTY1 autologin for $AKULA_USER"

sudo mkdir -p /etc/systemd/system/getty@tty1.service.d

sudo tee /etc/systemd/system/getty@tty1.service.d/autologin.conf > /dev/null << EOF
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin ${AKULA_USER} --noclear %I \$TERM
EOF

ok "Autologin configured"

# Sway autostart is handled by default/bash/bash_profile deployed in install/config.
