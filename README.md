# AkulaOS

> Fast. Stable. Visible. An Arch-based Linux remix for machines that should still matter.

**Akula** (Акула, "shark") is a minimal, constructivist-themed desktop built on
Arch Linux + Sway. Inspired structurally by Omarchy, redesigned for older hardware
and quieter aesthetics.

## Philosophy

1. **Fast first.** Idle RAM target: under 800 MB on 4 GB hardware. If a feature costs
   more than 50 MB, it earns its place or it doesn't ship.
2. **Stable second.** Curated package set. Arch official repos preferred; AUR only when
   unavoidable. No `-git` packages in defaults.
3. **Visible third.** Bold typography, 1px hairline rules, one accent colour.
   Designed once, applied everywhere — waybar, wofi, mako, swaylock, fzf, the terminal.

## Status

**Alpha — installable.** Run `bash install.sh` on a base Arch system.
Full install guide: [iso/airootfs/root/INSTALL.txt](iso/airootfs/root/INSTALL.txt)

A bootable installer ISO can be built with `sudo bash iso/build.sh` (requires `archiso`).

## What's included

| Layer | What |
|---|---|
| Window manager | Sway + swayidle + swaylock |
| Status bar | Waybar — workspaces, clock, cpu, ram, network, volume, battery |
| Launcher | Wofi (drun mode) |
| Notifications | Mako |
| Terminal | Foot — JetBrains Mono 11pt |
| Shell | Bash + Starship prompt + zoxide + fzf |
| Editor | Helix (default) + Nano (emergency) |
| Audio | PipeWire + WirePlumber |
| Network | NetworkManager + wpa_supplicant + UFW |
| Fonts | Inter · JetBrains Mono · PT Sans · PT Mono · Bebas Neue · Noto |
| Theming | GTK: Adwaita + Yaru icons · Qt: Kvantum |
| Branding | Constructivist palette; screensaver wallpaper via ImageMagick |

**Not in core (opt-in scripts):**

| Script | Installs |
|---|---|
| `akula-install-browser` | Firefox (~400 MB RSS active) |
| `akula-install-file-manager` | Thunar (~20 MB) |

## System requirements

- **RAM:** 4 GB minimum. Idle system sits at ~365 MB. Active use with a browser will
  exceed 800 MB — zram (installed by default at 50% RAM, zstd) is the buffer.
  The 800 MB target is for idle only.
- **CPU:** Intel i3/i5 (any generation) or equivalent AMD. Integrated graphics assumed.
- **Boot:** UEFI or BIOS. GRUB handles both.
- **Disk:** 30 GB minimum. Btrfs recommended.

## Design system

Constructivist Minimal. Colours locked — do not invent new ones.

| Variable | Hex | Role |
|---|---|---|
| `--akula-paper` | `#E8E2D0` | cream background |
| `--akula-ink` | `#1A1A1A` | deep text / dark bg |
| `--akula-steel` | `#2B2D33` | panel / chrome |
| `--akula-shadow` | `#0D0D0F` | void / lock screen |
| `--akula-red` | `#C41E1E` | signal accent |
| `--akula-rust` | `#8B2914` | secondary accent |
| `--akula-cyan` | `#2A6F7F` | tertiary, rare |
| `--akula-rule` | `#4A4A4A` | 1px hairlines |
| `--akula-mute` | `#8A8A82` | secondary text |

8px grid. 0px corner radius (2px max). No shadows. No blur. No gradients.
One accent colour per surface.

## License

Apache 2.0. See [LICENSE](LICENSE).
