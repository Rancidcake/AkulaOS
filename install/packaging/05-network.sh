#!/bin/bash
set -euo pipefail

info "Network + Firewall + Bluetooth"

pkg_install \
    networkmanager wpa_supplicant wireless-regdb \
    avahi nss-mdns \
    ufw \
    bluez bluez-utils

ok "Network, firewall, and Bluetooth installed"
