# AkulaOS — Open Questions

Items logged here are genuine ambiguities that need a decision before the relevant milestone.
Pick the most conservative available option when blocked, then log it here.

---

## OQ-001: Swap / zram configuration

**Question:** Should AkulaOS enable zram (compressed swap in RAM) by default on 4 GB machines?

**Why it matters:** With Firefox running (350-500 MB), the system approaches the 800 MB
idle budget. Heavy tab use will push into swap. Without any swap, the OOM killer fires.
With zram, compressed memory acts as a buffer.

**Conservative pick if needed:** Install `zram-generator` from pacman, enable a single
zram device at 50% of RAM (2 GB compressed). This is what Fedora does by default.

**Milestone:** Relevant at Milestone 2 (install modules) and Milestone 7 (ISO).

---

## OQ-002: Bluetooth support

**Question:** Should Bluetooth (bluez + bluetui) be in the default install?

**Why it matters:** Many target machines (Intel i3/i5 laptops) have Bluetooth hardware.
Without `bluez`, audio headphones and mice won't pair. But it adds ~15 MB idle.

**Conservative pick if needed:** Include `bluez` and `bluez-utils` in default. Enable
`bluetooth.service`. Do not include a heavy GUI (omarchy uses bluetui for TUI access).

**Milestone:** Milestone 1 package list, Milestone 2 services.

---

## OQ-003: Login manager upgrade path

**Question:** Decision 001 chose PAM autologin for v1. When should we add greetd?

**Why it matters:** greetd gives us a lock screen integration point and multi-user support.
Without it, `swaylock` is the only security layer (which is fine for single-user).

**Current answer:** Autologin for v1. Revisit before v0.2.

**Milestone:** Milestone 8 (polish) or a dedicated future milestone.

---

## OQ-004: Font licensing audit

**Question:** `ttf-paratype` (AUR) installs PT Sans + PT Mono. Are these OFL-licensed?

**Why it matters:** If we bundle fonts in the ISO, the license must be compatible with
our Apache 2.0 repo license.

**Known:** PT Sans and PT Mono are ParaType fonts released under the OFL (SIL Open Font
License). This is compatible. Needs confirmation when the AUR package is inspected.

**Milestone:** Milestone 5 (fonts stage) and Milestone 7 (ISO).

---

## OQ-005: File manager

**Question:** Include `thunar` (XFCE file manager, ~20 MB) or ship CLI-only?

**CLAUDE.md says:** Nothing explicit on file managers. README says nothing.

**Conservative pick:** Ship nothing in core. Users add thunar or nautilus themselves.
`eza`, `fd`, and `fzf` cover most CLI use cases. Document recommended optional installs.

**Milestone:** Milestone 1 (package list already excludes it), Milestone 8 (docs).

---

## OQ-006: Heavy browser + 800 MB RAM target

**Question:** If Firefox (~400 MB) + idle system (~365 MB) = ~765 MB, what happens with
multiple tabs or other open apps?

**Answer:** Users on 4 GB hardware will hit the limit with a browser + a second app.
`zram` (OQ-001) is the mitigation. The 800 MB target is for idle only; active use is
expected to exceed it temporarily.

**Document in:** README.md "System Requirements" section.

**Milestone:** Milestone 8 (docs).

---

## OQ-007: Wayland screen sharing

**Question:** `xdg-desktop-portal-wlr` enables screen sharing for wlroots compositors.
Does it work with Firefox/WebRTC screen sharing on Sway?

**Answer (best current knowledge):** Yes, with `pipewire` and `wireplumber` running.
Firefox on Wayland uses the portal. May require `MOZ_ENABLE_WAYLAND=1` env var.

**Action:** Test this in the Milestone 6 VM test. Log result here.

**Milestone:** Milestone 6 (VM test).
