# AkulaOS — Keybindings Reference

`Super` = the Windows/Command key (Mod4).

---

## Sway — window manager

### Core

| Key | Action |
|---|---|
| `Super + Enter` | Open terminal (foot) |
| `Super + D` | Open launcher (wofi) |
| `Super + Shift + Q` | Kill focused window |
| `Super + Shift + C` | Reload Sway config |
| `Super + Shift + E` | Exit Sway |

### Focus

| Key | Action |
|---|---|
| `Super + H / ← ` | Focus left |
| `Super + J / ↓` | Focus down |
| `Super + K / ↑` | Focus up |
| `Super + L / →` | Focus right |

### Move window

| Key | Action |
|---|---|
| `Super + Shift + H / ←` | Move left |
| `Super + Shift + J / ↓` | Move down |
| `Super + Shift + K / ↑` | Move up |
| `Super + Shift + L / →` | Move right |

### Layout

| Key | Action |
|---|---|
| `Super + B` | Split horizontal |
| `Super + V` | Split vertical |
| `Super + E` | Toggle split direction |
| `Super + S` | Stacking layout |
| `Super + W` | Tabbed layout |
| `Super + F` | Fullscreen |
| `Super + Shift + Space` | Toggle floating |
| `Super + Space` | Toggle focus tiling/floating |
| `Super + A` | Focus parent container |

### Workspaces

| Key | Action |
|---|---|
| `Super + 1–0` | Switch to workspace 1–10 |
| `Super + Shift + 1–0` | Move window to workspace 1–10 |
| `Super + Minus` | Show scratchpad |
| `Super + Shift + Minus` | Send window to scratchpad |

### Resize mode (`Super + R` to enter, `Escape` or `Enter` to leave)

| Key | Action |
|---|---|
| `H / ←` | Shrink width |
| `L / →` | Grow width |
| `K / ↑` | Shrink height |
| `J / ↓` | Grow height |

### Screenshots

| Key | Action |
|---|---|
| `Print` | Full screenshot → `~/Pictures/` |
| `Super + Print` | Region screenshot (drag to select) |

### Media and hardware

| Key | Action |
|---|---|
| `XF86AudioRaiseVolume` | Volume +5% |
| `XF86AudioLowerVolume` | Volume −5% |
| `XF86AudioMute` | Toggle mute |
| `XF86AudioPlay` | Play / pause |
| `XF86AudioNext / Prev` | Next / previous track |
| `XF86MonBrightnessUp` | Backlight +10% |
| `XF86MonBrightnessDown` | Backlight −10% |

---

## Helix — default editor (`hx`)

Helix is modal like vim but uses **selection-first** editing: select something, then act on it.

### Modes

| Key | Mode |
|---|---|
| `i` | Insert before selection |
| `a` | Insert after selection |
| `Escape` | Back to Normal mode |

### Movement (Normal mode)

| Key | Action |
|---|---|
| `h j k l` | Character/line movement |
| `w / b` | Next / previous word start |
| `e` | Next word end |
| `gg / ge` | File start / end |
| `Ctrl + d / u` | Half-page down / up |
| `Ctrl + f / b` | Full page down / up |

### Selection

| Key | Action |
|---|---|
| `x` | Select current line |
| `v` | Enter visual/extend mode |
| `%` | Select entire file |
| `s` | Select regex within selection |
| `S` | Split selection on regex |
| `Alt + s` | Split selection on newlines |

### Actions on selection

| Key | Action |
|---|---|
| `d` | Delete |
| `c` | Change (delete + insert) |
| `y` | Yank (copy) |
| `p` | Paste after |
| `P` | Paste before |
| `>` | Indent |
| `<` | Dedent |
| `~` | Toggle case |

### Search

| Key | Action |
|---|---|
| `/` | Search forward |
| `?` | Search backward |
| `n / N` | Next / previous match |
| `*` | Search for word under cursor |

### File and window

| Key | Action |
|---|---|
| `:w` | Write (save) |
| `:q` | Quit |
| `:wq` | Write and quit |
| `Space + f` | File picker |
| `Space + b` | Buffer picker |
| `Ctrl + w + v` | Vertical split |
| `Ctrl + w + s` | Horizontal split |
| `Ctrl + w + w` | Cycle splits |

### Undo / redo

| Key | Action |
|---|---|
| `u` | Undo |
| `U` | Redo |

---

## Shell — fzf keybindings

| Key | Action |
|---|---|
| `Ctrl + R` | Fuzzy search command history |
| `Ctrl + T` | Fuzzy insert file path at cursor |
| `Alt + C` | Fuzzy `cd` into a directory |

---

## Foot — terminal

| Key | Action |
|---|---|
| `Shift + Page Up / Down` | Scroll through output |
| `Ctrl + Shift + C` | Copy selection |
| `Ctrl + Shift + V` | Paste |
| `Ctrl + Shift + N` | Open new window |
| `Ctrl + +` | Increase font size |
| `Ctrl + -` | Decrease font size |
| `Ctrl + 0` | Reset font size |
