#!/usr/bin/env bash
# Runs chrooted into the built airootfs at the end of the archiso build step.
# Configures the live session — not the installed system.
set -euo pipefail

# Passwordless root for the live session — standard practice for installer ISOs.
passwd -d root

# Auto-login root on TTY1 so the MOTD install guide appears immediately on boot.
mkdir -p /etc/systemd/system/getty@tty1.service.d
cat > /etc/systemd/system/getty@tty1.service.d/autologin.conf << 'EOF'
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin root --noclear %I $TERM
EOF

# Services for the live session
systemctl enable NetworkManager.service
systemctl enable sshd.service
