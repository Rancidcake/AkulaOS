#!/bin/bash
set -euo pipefail

info "Base system packages"

pkg_install \
    grub efibootmgr os-prober \
    dosfstools btrfs-progs exfatprogs \
    polkit polkit-gnome gnome-keyring libsecret \
    kernel-modules-hook \
    base-devel git expac gum \
    man-db bash-completion \
    less jq unzip socat inetutils whois

ok "Base system packages installed"
