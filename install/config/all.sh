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
