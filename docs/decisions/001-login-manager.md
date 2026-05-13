---
title: 001 — Login Manager
date: 2026-05-14
status: decided
---

## Context

AkulaOS needs a way to start a Sway session after the system boots. Options range from
full graphical display managers to a single systemd override file.

The target user is Rancidcake building their first distro. Keeping things simple means
failure modes are easy to debug: a blank terminal beats a broken graphical login screen.

## Decision

**PAM autologin via getty service override.**

```
# /etc/systemd/system/getty@tty1.service.d/autologin.conf
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin USERNAME --noclear %I $TERM
```

In `~/.bash_profile`:
```bash
if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
  exec sway
fi
```

## Alternatives Considered

| Option | RAM idle | Notes |
|---|---|---|
| SDDM | ~30 MB + Qt5 (~150 MB of deps) | Graphical, familiar, but Qt5 adds massive dep chain |
| greetd + tuigreet | ~5 MB | Good middle ground; upgrade path from v1 |
| ly | ~2 MB | TUI display manager; less documented |
| **autologin (chosen)** | **0 MB** | No extra process; bash prompt on failure |

## Consequences

**Good:**
- Zero RAM overhead. Zero extra daemons.
- If Sway fails to start, the user lands on a bash prompt on TTY1 — the best possible
  failure mode for debugging.
- One file to explain, one file to audit.

**Bad:**
- Anyone with physical access to the machine can log in without a password. Acceptable for
  a personal workstation; not appropriate for shared or public machines.
- No pretty login screen for the first impression. This is noted in `docs/open-questions.md`
  as a candidate for v2 (greetd + akula-tuigreet theme).

**Upgrade path:** Install `greetd` + `tuigreet`, disable the getty override, enable
`greetd.service`. No other changes needed.
