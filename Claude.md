cat > CLAUDE.md << 'EOF'
# AkulaOS — Claude Code Working Notes

## What this is
AkulaOS is a fork-in-spirit (not a literal git fork) of basecamp/omarchy.
We borrow the structural pattern (install.sh + bin/ + config/) but build our own.

Repo: github.com/Rancidcake/AkulaOS
Reference: ../omarchy-upstream/ (read-only, do not modify)

## Three rules, in priority order
1. **Fast.** Idle RAM target: under 800 MB on 4 GB hardware.
   - Reject any default app that costs >50 MB unless it earns it.
   - Sway (Wayland), foot terminal, wofi launcher, waybar, mako notifications.
   - No Chromium, no Spotify, no LibreOffice in core install.
2. **Stable.** Arch packages preferred over AUR. AUR only when no alternative.
   - No -git packages in defaults.
   - Pin known-good versions for theming-related packages.
3. **Visible.** Strong typography, sparse accent color, no decoration without purpose.

## Design system — CONSTRUCTIVIST MINIMAL
Lock these. Do not invent new colors or fonts without asking.

### Palette (CSS-style variables)
--akula-paper:  #E8E2D0   /* cream background */
--akula-ink:    #1A1A1A   /* deep text / dark bg */
--akula-steel:  #2B2D33   /* panel / chrome */
--akula-shadow: #0D0D0F   /* void / lock */
--akula-red:    #C41E1E   /* signal accent */
--akula-rust:   #8B2914   /* secondary accent */
--akula-cyan:   #2A6F7F   /* tertiary, rare */
--akula-rule:   #4A4A4A   /* 1px hairlines */
--akula-mute:   #8A8A82   /* secondary text */

### Typography
- Latin UI:    Inter (sans), JetBrains Mono (mono)
- Cyrillic:    PT Sans / PT Mono
- Display:     Bebas Neue (branding, screensaver)
- Terminal:    JetBrains Mono 11pt default

### Layout rules
- 8px grid. Every spacing is a multiple of 8.
- 1px hairlines (#4A4A4A) preferred over fills for separation.
- Max corner radius: 2px. Default: 0.
- No shadows. No blur. No gradients.
- No more than ONE accent color per surface.
- Heavy 3-5px horizontal rules to separate major zones.

### Forbidden imagery
No hammer/sickle, red star, "СССР", any Soviet political iconography.
Cyrillic letters AS LETTERS are fine and encouraged.
We are channeling 1920s constructivism, not 1970s state propaganda.

## Naming
- Binaries:  akula-*   (e.g. akula-cmd-screensaver, akula-launch-menu)
- Configs:   ~/.config/akula/
- State:     ~/.local/state/akula/
- Branding:  branding/ in repo
- Brand:     "AkulaOS" in writing, "akula" in code

## Project layout
- bin/         CLI utilities (akula-* commands)
- install/     Installer modules called by install.sh
- config/      Default dotfiles copied to ~/.config/ on install
- default/     System-wide defaults (sway config, waybar, etc.)
- branding/    Logo ASCII, wallpapers, theme files
- migrations/  One-shot upgrade scripts (numbered: 001-name.sh)
- docs/        User-facing markdown
- iso/         (future) archiso config for bootable ISO

## Code conventions
- Bash: #!/bin/bash, then `set -euo pipefail` for installers (not for daemons).
- Each script does ONE thing. Compose, don't combine.
- Comments explain WHY, not WHAT.
- Prefer 5 short clear scripts over 1 long clever one.
- Every change: small commit, clear message.

## Dependencies
- pacman (Arch core)
- yay or paru (AUR helper — install if missing)
- Nothing else mandatory.

## What I (Rancidcake) am doing
Learning Linux + building my first distro. Explain non-obvious decisions.
When you propose code, give me a 3-line "why this approach" first.
Plan before write. Show diffs. Commit after I approve.

## Current status
Pre-alpha. Empty repo + LICENSE + this file. Start fresh.
EOF
