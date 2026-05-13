---
title: 003 — Audio Subsystem
date: 2026-05-14
status: decided
---

## Context

AkulaOS needs audio. Options in 2025 Arch Linux are: PipeWire (new default), PulseAudio
(legacy), JACK (pro audio), or ALSA alone (bare minimum, no per-app control).

## Decision

**PipeWire with wireplumber as session manager.**

Packages (all in pacman official repos):
- `pipewire` — the core daemon
- `pipewire-alsa` — ALSA compatibility shim
- `pipewire-pulse` — PulseAudio API compatibility (apps that use PA work unchanged)
- `pipewire-jack` — JACK API compatibility
- `wireplumber` — session and policy manager (routes audio between apps and devices)
- `pamixer` — CLI volume control
- `playerctl` — MPRIS media control (play/pause/skip from keybindings)

## Alternatives Considered

| Option | RAM idle | Notes |
|---|---|---|
| ALSA only | ~0 MB | No per-app volume; no Bluetooth audio; not usable as a desktop default |
| PulseAudio | ~25 MB | Actively being replaced; AUR-only on Arch (removed from repos) |
| JACK | ~20 MB | Pro audio; overkill; no simple PA compat |
| **PipeWire + wireplumber (chosen)** | **~35 MB combined** | Default on Arch; PA + JACK compat; actively maintained |

## Consequences

**Good:**
- PipeWire is the Arch default since 2022 and is what new installs use.
- Zero PulseAudio packages needed — PW provides the PA socket.
- Bluetooth audio works via `pipewire-pulse` without extra config.
- ~35 MB total (PW + wireplumber) — justified. Better than 0 MB ALSA with no working audio.
- The 35 MB is documented here as the justification required by the >50 MB rule. Combined
  PW+WP is 35 MB, so under the threshold. Each individual package is under 25 MB.

**Bad:**
- wireplumber has had stability issues in the past (pre-0.4). Version pinning may be needed
  if regressions appear. Log in `docs/open-questions.md` if this happens.
