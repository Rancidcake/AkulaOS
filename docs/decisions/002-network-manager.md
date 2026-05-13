---
title: 002 — Network Management
date: 2026-05-14
status: decided
---

## Context

AkulaOS must manage wifi (and ethernet) reliably during the install process and in the
running system. The install happens on unknown hardware with unknown wifi chips. The user
may not be comfortable with CLI-only wifi tools.

## Decision

**NetworkManager with wpa_supplicant backend.**

Package: `networkmanager` (pacman). Enable `NetworkManager.service`.

Key tool: `nmtui` — a terminal UI for connecting to wifi networks. This is the single most
important feature: it means a new user can set up wifi without memorizing `nmcli` syntax.

```bash
# Enable at install time:
systemctl enable NetworkManager.service
```

## Alternatives Considered

| Option | RAM idle | Notes |
|---|---|---|
| iwd alone | ~15 MB | `iwctl` is clean but CLI-only; no `nmtui` equivalent |
| NetworkManager + iwd backend | ~20 MB | iwd as backend for NM; good combo but adds complexity |
| **NetworkManager + wpa_supplicant (chosen)** | **~25 MB** | Most documented, nmtui is a lifesaver |
| systemd-networkd + iwd | ~12 MB | Minimal but no guided UI |

## Consequences

**Good:**
- `nmtui` is universally documented and familiar.
- NetworkManager has been the standard for a decade; every Arch wiki entry for wifi assumes it.
- Handles ethernet, wifi, VPN, and mobile broadband without additional packages.
- ~25 MB idle RAM — within our budget (only 3% of the 800 MB target).

**Bad:**
- Heavier than iwd alone by ~10 MB.
- The NM + wpa_supplicant combo is technically deprecated in favor of NM + iwd, but it is
  more stable and better tested across hardware in 2025.

**Future:** If the RAM budget becomes tight, replace wpa_supplicant with iwd as NM backend.
This is a one-line config change in `/etc/NetworkManager/conf.d/wifi-backend.conf`.
