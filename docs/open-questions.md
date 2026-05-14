# AkulaOS — Open Questions

All questions from the initial planning phase have been resolved.
New ambiguities go here as they arise.

---

## OQ-001: Swap / zram configuration — RESOLVED (M7)

**Question:** Should AkulaOS enable zram by default on 4 GB machines?

**Resolution:** Yes. `zram-generator` installed via pacman in M7 (02-base.sh).
Config at `default/zram/zram-generator.conf`: zram0 at 50% RAM, zstd compression.
zram-generator activates via systemd generator on boot — no explicit service enable
needed. Deployed to `/etc/systemd/zram-generator.conf` during install.

---

## OQ-002: Bluetooth support — RESOLVED (M2)

**Question:** Should Bluetooth be in the default install?

**Resolution:** Yes — conservative pick implemented. `bluez` + `bluez-utils` included
in `install/packaging/05-network.sh`. `bluetooth.service` enabled in post-install.
No Bluetooth GUI ships in core; use `bluetoothctl` for pairing.

---

## OQ-003: Login manager upgrade path — DEFERRED (v0.2)

**Question:** When should we add greetd?

**Resolution:** Not in v0.1. PAM autologin via getty@tty1 override remains the
approach for the initial release (Decision 001). greetd + tuigreet is the planned
upgrade: disable the getty override, enable `greetd.service`, configure a tuigreet
session pointing at sway. The work is one migration script.

**Tracked:** See `migrations/` — a future 001-greetd.sh will handle this.

---

## OQ-004: Font licensing audit — RESOLVED (M7)

**Question:** Are PT Sans + PT Mono OFL-licensed and compatible with Apache 2.0?

**Resolution:** Yes. PT Sans and PT Mono are released by ParaType under the SIL Open
Font License (OFL 1.1). OFL is permissive and compatible with Apache 2.0. Font bundles
in the ISO are fine. `ttf-bebas-neue` (AUR) is also OFL. `inter-font` is OFL.
`ttf-jetbrains-mono` is OFL. All four AUR fonts are clear.

---

## OQ-005: File manager — RESOLVED (M8)

**Question:** Include thunar or ship CLI-only?

**Resolution:** CLI-only in core. `eza`, `fd`, and `fzf` cover the common cases.
`bin/akula-install-file-manager` ships as an opt-in script that installs Thunar
(~20 MB idle) and sets it as the default via `xdg-mime`.

---

## OQ-006: Heavy browser + 800 MB RAM target — RESOLVED (M8)

**Question:** What happens when Firefox (~400 MB) + idle system (~365 MB) pushes past
800 MB with multiple tabs?

**Resolution:** Documented in README System Requirements section. The 800 MB target
is for the idle system only — active use is expected to exceed it temporarily.
zram (OQ-001) provides compressed swap as a buffer before the OOM killer fires.
Firefox is opt-in via `bin/akula-install-browser`; users on 4 GB hardware know what
they're trading when they install it.

---

## OQ-007: Wayland screen sharing — RESOLVED (M3 / M5)

**Question:** Does xdg-desktop-portal-wlr enable WebRTC screen sharing in Firefox on Sway?

**Resolution:** Yes. `xdg-desktop-portal-wlr` (installed in M2, 03-sway.sh) provides
the PipeWire screen capture backend for wlroots compositors. Firefox uses the portal
automatically when `MOZ_ENABLE_WAYLAND=1` is set — which is in `/etc/environment`
since M3 (install/config/all.sh). PipeWire + WirePlumber are installed and enabled as
user services (M2). No additional configuration needed.
