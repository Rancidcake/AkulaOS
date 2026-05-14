#!/bin/bash
set -euo pipefail

info "Audio (PipeWire)"

pkg_install \
    pipewire pipewire-alsa pipewire-pulse pipewire-jack \
    wireplumber gst-plugin-pipewire \
    alsa-utils pamixer playerctl

ok "Audio installed"
