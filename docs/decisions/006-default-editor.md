---
title: 006 — Default Text Editor
date: 2026-05-14
status: decided
---

## Context

AkulaOS needs at least one text editor available by default. Users will need to edit
config files, write scripts, and modify system files during setup and use.

Omarchy ships neovim with LazyVim (a full IDE-like neovim configuration). This is
opinionated and requires learning Lua config management. We want something usable
immediately without configuration.

## Decision

**Two editors: `nano` (emergency) and `helix` (default interactive).**

- `nano`: in base-devel or installable via `pacman -S nano`. Zero config needed. Used
  for quick edits and for users who don't know modal editors.
- `helix`: batteries-included modal editor. Out of the box: syntax highlighting, LSP
  support, multiple cursors, tree-sitter. No `init.lua` required to be functional.

Set `EDITOR=hx` and `VISUAL=hx` in `/etc/environment`. `nano` remains available as
`nano` directly.

## Alternatives Considered

| Option | Config needed | Notes |
|---|---|---|
| neovim (bare) | Yes (unusable without config) | Powerful but confusing default for new users |
| neovim + LazyVim | Yes (opinionated) | Omarchy approach; adds LazyVim startup time and complexity |
| vim | Minimal | Old; helix supersedes it for new users |
| **helix (chosen)** | **No** | Works well out of the box; modern keybindings; ~20 MB |
| **nano (emergency, chosen)** | **No** | Universal fallback; everyone knows Ctrl+X |
| emacs | Yes | Out of scope |

## Consequences

**Good:**
- New users can use `nano` immediately. Experienced users can use `helix`.
- Helix has no plugin system (intentionally) — no dependency hell.
- `hx file.conf` opens with syntax highlighting, line numbers, and selection feedback.
- ~20 MB installed for helix. Under the 50 MB threshold — no additional justification needed.

**Bad:**
- Not neovim. Users who want neovim/LazyVim install it themselves via `akula-install-editor`
  (future script). This is fine — neovim is not a core system tool.
- Helix has a different keybinding mental model than vim/neovim. Document in
  `docs/keybindings.md`.
