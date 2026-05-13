---
title: 007 — Web Browser
date: 2026-05-14
status: decided
---

## Context

CLAUDE.md explicitly forbids Chromium in core. A web browser is the highest-RAM
application a user will run — Firefox uses ~300-500 MB RSS when active.

The question is whether to include a browser in the base install or make it opt-in.

## Decision

**No browser in core install. Ship `akula-install-browser` as an opt-in helper.**

`akula-install-browser` will:
1. Present a choice: Firefox (recommended, pacman) or Brave (AUR, alternative)
2. Install the chosen browser
3. Set it as the default with `xdg-settings set default-web-browser`

## Alternatives Considered

| Option | RAM when running | Notes |
|---|---|---|
| Firefox in core | ~350-500 MB | Violates the 50 MB rule; must justify or drop |
| Chromium in core | ~400-600 MB | Explicitly forbidden by CLAUDE.md |
| Brave in core | ~400 MB | AUR; also heavy |
| Lynx/w3m in core | ~5 MB | Text browsers; not usable for modern web |
| **None in core (chosen)** | **0 MB at idle** | User opts in; respects the 50 MB rule |

## Consequences

**Good:**
- A fresh AkulaOS install has 0 MB of browser RAM overhead.
- The choice is explicit and deliberate — users know they're installing something heavy.
- Both Firefox (pacman) and Brave (AUR) are viable and documented.
- Respects CLAUDE.md rule 1 (Fast): "Reject any default app that costs >50 MB unless
  it earns it." A browser earns it, but only when the user asks for it.

**Bad:**
- The system cannot browse the web out of the box. A new user must run one command
  before they can use a browser. This is a known and intentional friction point.
- AkulaOS README should clearly state "no browser included" to set expectations.

**RAM justification (for when browser IS installed):**
Firefox at ~350-500 MB means total system idle (with browser running) is:
365 MB (idle) + 400 MB (Firefox) = ~765 MB — still under the 800 MB target on 4 GB hardware.
This is the theoretical maximum: one browser window + full desktop. It works, but barely.
Users with multiple tabs will exceed the target; swap/zram may be needed.
Log this in `docs/open-questions.md`.
