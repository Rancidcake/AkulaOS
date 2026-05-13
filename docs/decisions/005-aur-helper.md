---
title: 005 — AUR Helper
date: 2026-05-14
status: decided
---

## Context

Several required packages are AUR-only: `inter-font`, `ttf-paratype` (PT Sans + PT Mono),
`ttf-bebas-neue`, `kvantum-qt5`. We need an AUR helper to install these without manual
`git clone + makepkg` per package.

## Decision

**yay** (from AUR, written in Go).

Bootstrap install (requires `base-devel` and `git`):
```bash
cd /tmp
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
```

## Alternatives Considered

| Option | Language | Notes |
|---|---|---|
| **yay (chosen)** | Go | Well-documented; used by Omarchy; stable |
| paru | Rust | More actively maintained in 2025; feature-complete |
| pikaur | Python | Lighter; less tested |
| trizen | Perl | Old but works; poor emoji support in output |
| manual makepkg | Bash | No automation; not practical for 4+ AUR packages |

## Consequences

**Good:**
- yay is the most commonly referenced AUR helper in Arch documentation.
- Omarchy uses it — if we look at Omarchy patterns, the `omarchy-pkg-aur-add` wrapper
  calls yay under the hood.
- `yay -S package` is identical syntax to `pacman -S package` — zero learning curve.

**Bad:**
- Go runtime is compiled into the binary (~10 MB install).
- paru (Rust) is arguably more correct: it uses the AUR RPC API, has better diffs,
  and is more actively developed. However, yay works reliably and has more documentation.

**Upgrade path:** `yay -S paru` to install paru via yay, then remove yay if desired.
This is a one-command switch and has no effect on installed packages.

**Rule check:** yay itself is an AUR package (required to be installed from AUR by
bootstrapping). This is unavoidable. No -git packages are used (`yay`, not `yay-git`).
