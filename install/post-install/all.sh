#!/bin/bash
set -euo pipefail

# ── System services ───────────────────────────────────────────────────────────

info "System services"

sudo systemctl enable \
    NetworkManager.service \
    avahi-daemon.service \
    ufw.service \
    bluetooth.service \
    plocate-updatedb.timer

ok "System services enabled"

# ── User services (PipeWire audio stack) ──────────────────────────────────────

info "User audio services"

systemctl --user enable \
    pipewire.service \
    pipewire-pulse.service \
    wireplumber.service

ok "User services enabled"

# ── Firewall ──────────────────────────────────────────────────────────────────

info "Firewall rules"

sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable

ok "UFW enabled"

# ── Font cache ────────────────────────────────────────────────────────────────

info "Font cache"
fc-cache -f
ok "Font cache rebuilt"

# ── XDG user directories ──────────────────────────────────────────────────────

info "XDG user directories"
xdg-user-dirs-update
ok "User directories created"

# ── MIME defaults ─────────────────────────────────────────────────────────────

info "MIME defaults"

xdg-mime default mpv.desktop video/mp4
xdg-mime default mpv.desktop video/webm
xdg-mime default mpv.desktop audio/mpeg
xdg-mime default imv.desktop image/png
xdg-mime default imv.desktop image/jpeg
xdg-mime default imv.desktop image/webp
xdg-mime default org.gnome.Evince.desktop application/pdf

ok "MIME defaults set"

# ── Install flag ──────────────────────────────────────────────────────────────

flag_dir="$HOME/.config/akula"
mkdir -p "$flag_dir"
printf 'installed=%s\nversion=0.1.0\n' "$(date --iso-8601=seconds)" \
    > "$flag_dir/installed"

ok "Install flag written"

# ── Done ──────────────────────────────────────────────────────────────────────

fastfetch
printf '\nAkulaOS install complete. Reboot to start your Sway session.\n'
