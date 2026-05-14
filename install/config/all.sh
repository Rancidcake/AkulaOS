#!/bin/bash
set -euo pipefail

# ── GRUB ─────────────────────────────────────────────────────────────────────

info "GRUB bootloader"

if [[ -d /sys/firmware/efi ]]; then
    sudo grub-install \
        --target=x86_64-efi \
        --efi-directory=/boot/efi \
        --bootloader-id=AkulaOS
else
    # BIOS: detect the disk containing the root partition
    root_dev=$(findmnt -no SOURCE /)
    root_disk=$(lsblk -no pkname "$root_dev" 2>/dev/null | head -1)

    if [[ -z "$root_disk" ]]; then
        warn "Could not auto-detect root disk."
        root_disk=$(gum input --placeholder "Enter disk device for GRUB, e.g. sda")
        [[ -n "$root_disk" ]] || fail "No disk provided — aborting GRUB install."
    fi

    sudo grub-install --target=i386-pc "/dev/$root_disk"
fi

sudo grub-mkconfig -o /boot/grub/grub.cfg
ok "GRUB installed"

# ── mDNS (avahi + nss-mdns) ──────────────────────────────────────────────────

info "mDNS resolver"

# Insert mdns_minimal [NOTFOUND=return] before dns in the hosts line so that
# .local names resolve via avahi without falling through to the DNS server.
if ! grep -q 'mdns_minimal' /etc/nsswitch.conf; then
    sudo sed -i '/^hosts:/ s/\bdns\b/mdns_minimal [NOTFOUND=return] dns/' \
        /etc/nsswitch.conf
fi

ok "mDNS configured"

# ── System environment ────────────────────────────────────────────────────────

info "System environment"

sudo tee /etc/environment > /dev/null << 'EOF'
EDITOR=hx
VISUAL=hx
MOZ_ENABLE_WAYLAND=1
EOF

ok "System environment set"

# ── Dotfile deployment ────────────────────────────────────────────────────────

info "Deploying default configs"

_AKULA_DIR="${AKULA_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
_DEF="$_AKULA_DIR/default"

# Sway config goes system-wide so the /etc/sway/config.d/ include path works
sudo mkdir -p /etc/sway/config.d
sudo install -m 644 "$_DEF/sway/config" /etc/sway/config

# Per-user configs
install -Dm 644 "$_DEF/waybar/config.jsonc"      "$HOME/.config/waybar/config.jsonc"
install -Dm 644 "$_DEF/waybar/style.css"          "$HOME/.config/waybar/style.css"
install -Dm 644 "$_DEF/mako/config"               "$HOME/.config/mako/config"
install -Dm 644 "$_DEF/foot/foot.ini"             "$HOME/.config/foot/foot.ini"
install -Dm 644 "$_DEF/wofi/config"               "$HOME/.config/wofi/config"
install -Dm 644 "$_DEF/wofi/style.css"            "$HOME/.config/wofi/style.css"
install -Dm 644 "$_DEF/starship/starship.toml"    "$HOME/.config/starship.toml"
install -Dm 644 "$_DEF/akula/palette.sh"          "$HOME/.config/akula/palette.sh"
install -Dm 644 "$_DEF/bash/bashrc"                  "$HOME/.bashrc"
install -Dm 644 "$_DEF/bash/bash_profile"            "$HOME/.bash_profile"
install -Dm 644 "$_DEF/swaylock/config"              "$HOME/.config/swaylock/config"
install -Dm 644 "$_DEF/fontconfig/fonts.conf"        "$HOME/.config/fontconfig/fonts.conf"
install -Dm 644 "$_DEF/gtk-3.0/settings.ini"         "$HOME/.config/gtk-3.0/settings.ini"
install -Dm 644 "$_DEF/gtk-4.0/settings.ini"         "$HOME/.config/gtk-4.0/settings.ini"

# zram: system-level config; zram-generator activates it via systemd on boot
sudo install -Dm 644 "$_AKULA_DIR/default/zram/zram-generator.conf" \
    /etc/systemd/zram-generator.conf

ok "Configs deployed"

# ── bin/ scripts → ~/.local/bin ───────────────────────────────────────────────

info "Installing akula-* binaries"

mkdir -p "$HOME/.local/bin"
install -Dm 755 "$_AKULA_DIR/bin/"akula-* "$HOME/.local/bin/"

# Add ~/.local/bin to PATH if not already present
if ! grep -q '\.local/bin' "$HOME/.bash_profile" 2>/dev/null; then
    printf '\nexport PATH="$HOME/.local/bin:$PATH"\n' >> "$HOME/.bash_profile"
fi

ok "Binaries installed to ~/.local/bin"
