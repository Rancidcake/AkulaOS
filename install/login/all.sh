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

# ── Auto-start Sway on TTY1 login ────────────────────────────────────────────

info "Sway autostart in ~/.bash_profile"

# Only append if not already present (installer is safe to re-run)
if ! grep -q 'exec sway' "$HOME/.bash_profile" 2>/dev/null; then
    cat >> "$HOME/.bash_profile" << 'EOF'

# AkulaOS: start Sway on first TTY login
if [[ -z "${DISPLAY:-}" ]] && [[ "$(tty)" = "/dev/tty1" ]]; then
    exec sway
fi
EOF
fi

ok "Sway autostart configured"
