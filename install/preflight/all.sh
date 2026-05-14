#!/bin/bash
set -euo pipefail

info "Preflight checks"

# Must run as non-root user with sudo access
[[ $EUID -ne 0 ]] \
    || fail "Run the installer as your regular user, not root."
sudo -v 2>/dev/null \
    || fail "sudo is not available. Run 'visudo' and add yourself first."

# Must be Arch Linux
grep -q 'ID=arch' /etc/os-release 2>/dev/null \
    || fail "AkulaOS requires Arch Linux."

# Internet connectivity
ping -c 1 -W 5 archlinux.org &>/dev/null \
    || fail "No internet connection. Connect and retry."

# Disk space: at least 10 GB free on /
free_kb=$(df / --output=avail | tail -1)
(( free_kb >= 10 * 1024 * 1024 )) \
    || warn "Less than 10 GB free on /. Install may run out of space."

# RAM: at least 2 GB total
total_kb=$(grep MemTotal /proc/meminfo | awk '{print $2}')
(( total_kb >= 2 * 1024 * 1024 )) \
    || warn "Less than 2 GB RAM detected. System may be slow during install."

ok "Preflight passed"
