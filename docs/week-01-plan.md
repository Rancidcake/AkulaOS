# AkulaOS — Week 1 Plan: Package List, Exclusions, Install Stages

> Generated from context review: CLAUDE.md, README.md, omarchy-upstream/install.sh,
> bin/ + install/ + default/ file lists, and the full omarchy-base.packages list.
> No code has been written yet. This is the planning document for review.

---

## Step 1 — What I Learned (5 bullets)

1. **Sway, not Hyprland.** Omarchy is built entirely around Hyprland (20+ `omarchy-hyprland-*`
   scripts, `hypridle`, `hyprlock`, `hyprsunset`, `xdg-desktop-portal-hyprland`). None of that
   ports directly — every Hyprland binary gets replaced or dropped, not adapted.

2. **Omarchy's base package list is heavy by design.** The 100+ package list in
   `omarchy-base.packages` includes Chromium, Docker, LibreOffice, Spotify, OBS, Kdenlive,
   Typora, 1Password, and Signal by default. That's a lifestyle OS for a specific professional;
   AkulaOS is a lean platform. We keep the structural pattern, not the opinions.

3. **Omarchy's install structure is a clean model to follow.** Six sourced stages in order:
   `helpers → preflight → packaging → config → login → post-install`. Each stage is a directory
   with an `all.sh` aggregator. This composable pattern works well and we should copy it.

4. **The AUR dependency is real and unavoidable for our fonts.** The required typefaces
   (Inter, PT Sans, PT Mono, Bebas Neue) are all AUR-only. We need a working AUR helper
   before the fonts stage. `yay` (already in Omarchy) is the pragmatic choice.

5. **Omarchy assumes modern/premium hardware; we target commodity older boxes.** Omarchy
   ships with NVIDIA dkms, Framework 16, ASUS ROG, Dell XPS, Apple T2, and Surface support
   baked in. Our target is Intel i3/i5 + integrated graphics — hardware that "should still
   matter." We can strip all OEM-specific modules from the default install path.

---

## Step 2 — Package List

**RAM cost** = idle RSS of the running process/daemon (for libraries and fonts that don't
run as daemons, this is ~0 at idle — the figure reflects install-time footprint only).
**AUR** packages are flagged explicitly; all others are pacman (official repos).

| Package | Category | Why we need it | RAM cost (idle) | From Omarchy? |
|---|---|---|---|---|
| `linux` | base-system | The kernel | — | No (we provide our own) |
| `linux-firmware` | base-system | Hardware microcode and firmware blobs | — | Yes (other.packages) |
| `base` | base-system | Core userland (glibc, bash, coreutils) | — | No (Arch bootstrap) |
| `base-devel` | base-system | Build tools; required to compile AUR packages | — | No (Arch bootstrap) |
| `limine` | base-system | Bootloader — modern, fast, UEFI+BIOS; what Omarchy uses | <1 MB | Yes (other.packages) |
| `efibootmgr` | base-system | Manage UEFI boot entries | <1 MB | No |
| `dosfstools` | base-system | Format/repair FAT32 EFI partition | <1 MB | Yes |
| `btrfs-progs` | base-system | Btrfs filesystem tools (default fs) | <1 MB | Yes (other.packages) |
| `exfatprogs` | base-system | exFAT support for external drives | <1 MB | Yes |
| `polkit` | base-system | Policy-based privilege delegation | ~5 MB | Yes (via polkit-gnome) |
| `polkit-gnome` | base-system | Polkit authentication agent for GTK sessions | ~30 MB | Yes |
| `gnome-keyring` | base-system | Secret storage (SSH keys, passwords) | ~15 MB | Yes |
| `libsecret` | base-system | Library for gnome-keyring access | <1 MB | Yes |
| `kernel-modules-hook` | base-system | Rebuild modules on kernel update without mkinitcpio pain | <1 MB | Yes |
| `yay` | base-system | AUR helper — required for font and theming packages | ~10 MB (build only) | Yes |
| `expac` | base-system | Query pacman database; used in akula helper scripts | <1 MB | Yes |
| `sway` | window-manager | Wayland compositor — our core WM | ~30 MB | No |
| `swayidle` | window-manager | Idle timeout → lock + display off | ~2 MB | No |
| `swaylock` | window-manager | Screen locker for Sway | ~10 MB | No |
| `swaybg` | window-manager | Wallpaper setter (replaces hyprpaper) | <1 MB | Yes |
| `uwsm` | window-manager | Universal Wayland Session Manager — proper systemd integration for sway | ~5 MB | Yes |
| `xdg-desktop-portal` | window-manager | Base portal daemon (file picker, screen share) | ~10 MB | Yes (implicitly) |
| `xdg-desktop-portal-wlr` | window-manager | wlroots portal backend for Sway | ~5 MB | No (Omarchy uses hyprland variant) |
| `xdg-desktop-portal-gtk` | window-manager | GTK file picker, opens-with dialog | ~15 MB | Yes |
| `waybar` | window-manager | Status bar — supports Sway natively | ~20 MB | Yes |
| `mako` | window-manager | Notification daemon — minimal, Wayland-native | ~5 MB | Yes |
| `wofi` | window-manager | App launcher — GTK, Wayland-native; replaces walker | ~10 MB (launch only) | No |
| `grim` | window-manager | Screenshot capture (Wayland) | <1 MB | Yes |
| `slurp` | window-manager | Region selection for grim | <1 MB | Yes |
| `wl-clipboard` | window-manager | `wl-copy` / `wl-paste` — clipboard integration | <1 MB | Yes |
| `brightnessctl` | window-manager | Backlight control via sysfs | <1 MB | Yes |
| `foot` | terminal | Wayland-native terminal — fastest option, ~15 MB idle | ~15 MB | No (Omarchy uses alacritty/ghostty) |
| `tmux` | terminal | Terminal multiplexer — sessions, splits | ~5 MB | Yes |
| `bash-completion` | terminal | Tab completion for bash | <1 MB | Yes |
| `starship` | terminal | Shell prompt — fast, written in Rust | <1 MB | Yes |
| `pipewire` | audio | Modern audio server — replaces PulseAudio + JACK | ~20 MB | Yes (other.packages) |
| `pipewire-alsa` | audio | ALSA compatibility shim | <1 MB | Yes (other.packages) |
| `pipewire-pulse` | audio | PulseAudio API compatibility | ~5 MB | Yes (other.packages) |
| `pipewire-jack` | audio | JACK API compatibility | <1 MB | Yes (other.packages) |
| `wireplumber` | audio | Session/policy manager for pipewire | ~15 MB | Yes |
| `gst-plugin-pipewire` | audio | GStreamer ↔ pipewire bridge | ~5 MB | Yes (other.packages) |
| `alsa-utils` | audio | `aplay`, `arecord`, `amixer` — low-level ALSA tools | ~2 MB | Yes |
| `pamixer` | audio | CLI volume control for pipewire/PA | <1 MB | Yes |
| `playerctl` | audio | MPRIS media player control (play/pause/next) | ~2 MB | Yes |
| `iwd` | network | Modern wifi daemon — leaner than NetworkManager | ~15 MB | Yes |
| `inetutils` | network | `ping`, `hostname`, `ftp`, basic network utilities | <1 MB | Yes |
| `wireless-regdb` | network | Wireless regulatory domain database | <1 MB | Yes |
| `ufw` | network | Firewall — simple iptables frontend | ~5 MB | Yes |
| `avahi` | network | mDNS/DNS-SD for local network discovery | ~10 MB | Yes |
| `nss-mdns` | network | mDNS resolver plugin for glibc | <1 MB | Yes |
| `whois` | network | WHOIS client | <1 MB | Yes |
| `ttf-jetbrains-mono` | fonts | **Primary mono font** — terminal + code; **Cyrillic: YES** | 0 | No (Omarchy uses nerd variant) |
| `inter-font` **(AUR)** | fonts | **Primary UI sans** — waybar, wofi, GTK apps; **Cyrillic: YES** | 0 | No |
| `ttf-paratype` **(AUR)** | fonts | Installs **PT Sans + PT Mono** — Cyrillic-first design; **Cyrillic: YES** | 0 | No |
| `ttf-bebas-neue` **(AUR)** | fonts | **Display / branding** — screensaver, splash; **Cyrillic: NO** (Latin only) | 0 | No |
| `noto-fonts` | fonts | Unicode fallback — covers gaps Inter/JBM leave; **Cyrillic: YES** | 0 | Yes |
| `noto-fonts-emoji` | fonts | Emoji rendering in waybar and terminal | 0 | Yes |
| `fontconfig` | fonts | Font rendering configuration | 0 | Yes |
| `gnome-themes-extra` | theming | Adwaita + HighContrast GTK themes — base for overrides | ~15 MB | Yes |
| `yaru-icon-theme` | theming | Icon theme — clean, not icon-heavy | ~50 MB installed | Yes |
| `kvantum-qt5` **(AUR)** | theming | Qt5 theme engine — apply GTK-consistent style to Qt5 apps | ~20 MB | Yes |
| `qt5-wayland` | theming | Qt5 Wayland backend | ~10 MB | Yes |
| `qt6-wayland` | theming | Qt6 Wayland backend | ~10 MB | Yes (other.packages) |
| `gnome-disk-utility` | theming | GUI disk manager — rare but useful when needed | ~30 MB | Yes |
| `btop` | utilities | System monitor TUI — process/CPU/RAM/disk/net | ~10 MB | Yes |
| `fastfetch` | utilities | System info display for login / about screen | ~5 MB | Yes |
| `fzf` | utilities | Fuzzy finder — used in launcher and shell scripts | <1 MB | Yes |
| `ripgrep` | utilities | Fast recursive grep — replaces grep in scripts | <1 MB | Yes |
| `bat` | utilities | `cat` with syntax highlighting | <1 MB | Yes |
| `eza` | utilities | Modern `ls` with icons and git status | <1 MB | Yes |
| `fd` | utilities | Modern `find` — used in akula scripts | <1 MB | Yes |
| `git` | utilities | VCS — required for AUR builds and config management | ~5 MB | Yes (base-devel) |
| `lazygit` | utilities | Git TUI — comfortable interface for git operations | ~10 MB | Yes |
| `less` | utilities | Pager for man pages and log viewing | <1 MB | Yes |
| `jq` | utilities | JSON processor — essential for script plumbing | <1 MB | Yes |
| `unzip` | utilities | Archive extraction | <1 MB | Yes |
| `zoxide` | utilities | Smart `cd` with frecency | <1 MB | Yes |
| `tldr` | utilities | Simplified man pages | <1 MB | Yes |
| `man-db` | utilities | Man page viewer | ~5 MB | Yes |
| `dust` | utilities | Disk usage viewer with tree layout | <1 MB | Yes |
| `plocate` | utilities | Fast file search (updatedb-based) | ~5 MB | Yes |
| `gum` | utilities | Shell UI toolkit — used in akula interactive scripts | ~5 MB | Yes |
| `imagemagick` | utilities | Image processing — used in theming and screenshot scripts | ~25 MB | Yes |
| `imv` | utilities | Lightweight image viewer for Wayland | ~5 MB | Yes |
| `mpv` | utilities | Media player — justified by use; no GUI overhead at idle | ~30 MB | Yes |
| `evince` | utilities | PDF/document viewer — minimal GNOME viewer | ~30 MB | Yes |
| `xdg-terminal-exec` | utilities | Default terminal abstraction | <1 MB | Yes |
| `socat` | utilities | Socket relay — used in some sway IPC scripts | <1 MB | Yes |
| `github-cli` | dev-tools | GitHub CLI — useful for akula development workflow | ~15 MB | Yes |
| `mise` | dev-tools | Runtime version manager (node, python, ruby) — opt-in, not active at idle | ~10 MB (build only) | Yes |
| `git` | dev-tools | Already listed in utilities | — | — |

**Estimated idle RAM budget (running daemons only):**

| Component | Idle RSS |
|---|---|
| kernel + systemd | ~200 MB |
| sway (empty session) | ~30 MB |
| waybar | ~20 MB |
| foot (1 window) | ~15 MB |
| pipewire + wireplumber | ~35 MB |
| mako | ~5 MB |
| iwd | ~15 MB |
| gnome-keyring | ~15 MB |
| polkit-gnome | ~30 MB |
| **Total** | **~365 MB** |

Comfortable margin to the 800 MB target. A browser session (Firefox ~300–500 MB RSS) still
fits within budget without swapping on 4 GB hardware.

---

## Step 3 — Omarchy Modules NOT to Port

### From `install/` directories

| Path | Reason to exclude |
|---|---|
| `install/packaging/webapps.sh` | Installs Basecamp, HEY, Zoom, WhatsApp webapps — 37signals-specific product set |
| `install/packaging/npm.sh` | Installs Codex, Gemini CLI, Copilot, opencode, Playwright — heavy AI dev tooling, not core |
| `install/packaging/nvim.sh` | Installs LazyVim with Omarchy's opinionated config — we'll ship our own or nothing |
| `install/packaging/asus-rog.sh` | ASUS ROG-specific RGB and fan control — OEM hardware we don't target |
| `install/packaging/framework16.sh` | Framework 16 power and display tuning — OEM hardware we don't target |
| `install/packaging/dell-xps-touchpad-haptics.sh` | Dell XPS haptic touchpad daemon — OEM hardware we don't target |
| `install/packaging/surface.sh` | Microsoft Surface kernel and drivers — OEM hardware we don't target |
| `install/config/docker.sh` | Docker daemon setup — not in AkulaOS core; heavy RAM cost |
| `install/config/omarchy-ai-skill.sh` | Installs Omarchy's own AI skill file — Omarchy branding, not ours |
| `install/config/mise-work.sh` | Activates 37signals internal toolchain config — company-specific |
| `install/config/gnome-theme.sh` | Sets GNOME gsettings for Omarchy themes — we'll have akula-theme equivalent |
| `install/config/nautilus-python.sh` | Nautilus Python extensions for Omarchy file menu — Omarchy-specific feature |
| `install/config/pi.sh` | Installs Pi coding agent (earendil-works) — Omarchy-specific AI tool |
| `install/login/sddm.sh` | SDDM display manager setup — decision pending (see Step 5) |
| `install/login/plymouth.sh` | Boot splash screen — optional, adds ~50 MB to initramfs; skip for v1 |
| `install/post-install/gnome-theme.sh` | Applies Omarchy GNOME theme — replaced by akula theming |
| `install/post-install/welcome.sh` | Shows Omarchy welcome message — replaced by akula-first-run |

### From `bin/` (by functional group)

| Group | Scripts | Reason to exclude |
|---|---|---|
| Hyprland WM | `omarchy-hyprland-*` (~22 scripts), `omarchy-refresh-hyprland`, `omarchy-refresh-hypridle`, `omarchy-refresh-hyprlock`, `omarchy-refresh-hyprsunset`, `omarchy-style-corners-hyprland`, `omarchy-style-corners-hyprlock` | We use Sway — entire Hyprland IPC layer is incompatible |
| Gaming | `omarchy-games-retro-*`, `omarchy-install-gaming-*`, `omarchy-remove-gaming-*` (12 scripts) | Gaming scope excluded from core; too RAM-heavy (Steam, Heroic, Lutris) |
| Voice AI | `omarchy-voxtype-*` (5 scripts) | AI voice input daemon — RAM and latency cost not justified in core |
| Branding | `omarchy-branding-about`, `omarchy-branding-screensaver`, `omarchy-show-logo`, `omarchy-show-done` | Omarchy-specific branding; we ship our own |
| Walker launcher | `omarchy-refresh-walker`, `omarchy-launch-walker`, `omarchy-menu-*` (5 scripts) | Walker requires Chromium/electron — replaced by wofi |
| Chromium | `omarchy-install-chromium-google-account`, `omarchy-theme-set-browser`, `omarchy-refresh-chromium` | No Chromium in core |
| Docker | `omarchy-install-docker-dbs` | No Docker in core |
| OEM hardware | `omarchy-hw-asus-expertbook-b9406`, `omarchy-hw-asus-rog`, `omarchy-hw-asus-zenbook-ux5406aa`, `omarchy-hw-dell-xps-*`, `omarchy-hw-framework16`, `omarchy-hw-surface` | OEM-specific; not our target hardware |
| Cloud storage | `omarchy-install-dropbox` | Proprietary sync daemon, not in core |
| VPN | `omarchy-install-nordvpn` | Proprietary VPN, not in core |
| Zoom webapp | `omarchy-webapp-handler-zoom`, `omarchy-webapp-handler-hey` | Zoom excluded from core; HEY is 37signals product |
| Windows VM | `omarchy-windows-vm` | QEMU/KVM VM management — out of scope for v1 |
| SDDM | `omarchy-refresh-sddm` | Only relevant if we use SDDM (decision pending) |
| SwayOSD | `omarchy-swayosd-*`, `omarchy-refresh-swayosd` | Keep under review — may port for volume/brightness OSD, but it has a dbus dependency worth auditing |

---

## Step 4 — install.sh Structural Plan

```
install.sh
  source install/helpers/all.sh
  source install/preflight/all.sh
  source install/packaging/all.sh
  source install/config/all.sh
  source install/login/all.sh
  source install/post-install/all.sh
```

---

### Stage 01 — Preflight

**Purpose:** Abort early on conditions that will cause mid-install failures.

**Does:**
- Verify running as the target user (not root), with sudo available
- Check internet connectivity (`ping -c 1 archlinux.org`)
- Confirm we are on Arch Linux (check `/etc/os-release`)
- Warn if available disk < 10 GB or RAM < 2 GB

**Failure mode:** Script exits with a clear message before any packages are touched.
Safe to retry after fixing the condition.

---

### Stage 02 — Pacman Setup

**Purpose:** Get pacman into a reliable state before installing anything.

**Does:**
- Refresh keyring (`pacman-key --populate archlinux`)
- Set parallel downloads to 5 in `pacman.conf`
- Enable the `multilib` repo (needed for some 32-bit audio/graphics libs)
- Run `pacman -Syu` to ensure the system is fully updated before adding packages

**Failure mode:** If keyring refresh fails, subsequent package installs will fail signature
checks. Must be fixed and retried. Not safe to skip.

---

### Stage 03 — AUR Helper

**Purpose:** Install `yay` so all subsequent stages can use AUR packages.

**Does:**
- Check if `yay` is already installed; skip if so
- Clone `yay` from AUR into a temp dir and `makepkg -si`
- Verify `yay --version` succeeds before continuing

**Failure mode:** If the AUR is down or `base-devel` is missing, this fails. Retryable.
Fonts and some theming packages depend on this stage completing successfully.

---

### Stage 04 — Base System Packages

**Purpose:** Install the non-WM foundation: bootloader, filesystem tools, polkit, keyring,
kernel update hooks.

**Does:**
- Install `limine`, `efibootmgr`, `dosfstools`, `btrfs-progs`, `exfatprogs`
- Install `polkit`, `polkit-gnome`, `gnome-keyring`, `libsecret`
- Install `kernel-modules-hook`, `man-db`, `bash-completion`, `git`, `expac`, `gum`
- Install `unzip`, `less`, `jq`, `socat`, `inetutils`, `whois`

**Failure mode:** A missing package here will likely break later stages. Retryable; no
system state has been mutated beyond package installation.

---

### Stage 05 — Wayland + Sway

**Purpose:** Install the window manager, portals, and Wayland plumbing.

**Does:**
- Install `sway`, `swaybg`, `swayidle`, `swaylock`, `uwsm`
- Install `xdg-desktop-portal`, `xdg-desktop-portal-wlr`, `xdg-desktop-portal-gtk`
- Install `waybar`, `mako`, `wofi`
- Install screenshot tools: `grim`, `slurp`; clipboard: `wl-clipboard`; backlight: `brightnessctl`

**Failure mode:** If `sway` fails to install (rare but possible with partial db), the system
has no WM. Retryable. The live install session is still usable via TTY.

---

### Stage 06 — Audio

**Purpose:** Set up the full pipewire audio stack.

**Does:**
- Install `pipewire`, `pipewire-alsa`, `pipewire-pulse`, `pipewire-jack`, `wireplumber`
- Install `gst-plugin-pipewire`, `alsa-utils`, `pamixer`, `playerctl`
- Enable `pipewire.service` and `wireplumber.service` as user units

**Failure mode:** Audio is non-critical for the installer to proceed; the session will boot
silently if this fails. Can be retried independently.

---

### Stage 07 — Network + Firewall

**Purpose:** Ensure network management persists after reboot and apply basic firewall rules.

**Does:**
- Install `iwd` (wifi) and `wireless-regdb`
- Install `avahi`, `nss-mdns` and configure `/etc/nsswitch.conf` for mDNS
- Install `ufw`; enable with default deny-incoming / allow-outgoing
- Enable `iwd.service` and `avahi-daemon.service`

**Failure mode:** Network breaks at reboot if iwd isn't enabled. Dangerous to skip. Retryable,
but must be verified before rebooting.

---

### Stage 08 — Fonts

**Purpose:** Install all required typefaces including AUR fonts.

**Does:**
- Install via pacman: `ttf-jetbrains-mono`, `noto-fonts`, `noto-fonts-emoji`, `fontconfig`
- Install via yay (AUR): `inter-font`, `ttf-paratype` (PT Sans + PT Mono), `ttf-bebas-neue`
- Run `fc-cache -f` to rebuild font cache

**Failure mode:** If AUR is unavailable, Cyrillic UI fonts are missing. System still boots and
runs but looks wrong. Can be retried independently.

---

### Stage 09 — Theming

**Purpose:** Install GTK/Qt theming layer and icons.

**Does:**
- Install `gnome-themes-extra`, `yaru-icon-theme`
- Install `qt5-wayland`, `qt6-wayland`, `kvantum-qt5` (AUR)
- Copy `branding/akula.theme` and set GTK2/GTK3/GTK4 settings
- Set icon theme and cursor theme

**Failure mode:** Falls back to default GTK theme. Cosmetic only. Retryable.

---

### Stage 10 — Terminal, Shell, and Utilities

**Purpose:** Install the terminal emulator, shell tooling, and core utilities.

**Does:**
- Install `foot`, `tmux`, `starship`
- Install utilities: `btop`, `fastfetch`, `fzf`, `ripgrep`, `bat`, `eza`, `fd`, `zoxide`,
  `lazygit`, `dust`, `plocate`, `tldr`, `imagemagick`, `imv`, `mpv`, `evince`, `xdg-terminal-exec`
- Install dev-adjacent tools: `github-cli`, `mise`

**Failure mode:** Missing utilities are inconvenient but don't break boot. Fully retryable.

---

### Stage 11 — Config Deployment

**Purpose:** Place akula dotfiles into `~/.config/` and system defaults.

**Does:**
- Copy `default/sway/` → `/etc/sway/`; `default/waybar/` → `~/.config/waybar/`
- Copy `default/mako/` → `~/.config/mako/`; `default/foot/` → `~/.config/foot/`
- Copy `default/akula/` → `~/.config/akula/` (palette, font settings, state)
- Copy `default/wofi/` → `~/.config/wofi/`

**Failure mode:** If configs fail to copy (permissions), sway will start with defaults.
Retryable without side effects (files are copied, not symlinked).

---

### Stage 12 — System Services

**Purpose:** Enable all systemd units that should survive reboot.

**Does:**
- Enable user units: `pipewire`, `wireplumber`, `mako`
- Enable system units: `iwd`, `avahi-daemon`, `ufw`, `polkit`, `gnome-keyring`
- Configure `plocate` updatedb timer
- Set up login session (greetd or autologin — TBD per Step 5 question 1)

**Failure mode:** A failed enable means the service won't start at boot but can be enabled
manually. Use `systemctl --failed` post-reboot to check. Retryable.

---

### Stage 13 — Post-Install + First Run

**Purpose:** Final system tuning and handoff to the user.

**Does:**
- Set user dirs (`xdg-user-dirs-update`)
- Configure MIME type defaults (foot as terminal, mpv as video, imv as images)
- Set firewall rules to persist across reboots (`ufw enable`)
- Write `/etc/skel/.config/akula/installed` flag to track install completion
- Print install summary with `fastfetch` + akula branding

**Failure mode:** Non-critical — system is functional at this point. Each step is idempotent.
Retryable.

---

## Step 5 — Decisions Made (Conservative Picks)

Each decision is documented in full in `docs/decisions/`. Conservative = fewest moving parts,
most established, least likely to break on unknown hardware.

| # | Decision | Choice | Rationale | Doc |
|---|---|---|---|---|
| 1 | Login manager | PAM autologin → TTY1 → `exec sway` | Zero extra processes; if sway fails, user gets a bash prompt for debugging | [001](decisions/001-login-manager.md) |
| 2 | Network management | NetworkManager + wpa_supplicant | `nmtui` is invaluable for wifi setup on unknown hardware; decades of docs | [002](decisions/002-network-manager.md) |
| 3 | Audio | PipeWire + wireplumber | Default on Arch 2025; PA and JACK compat built in | [003](decisions/003-audio.md) |
| 4 | Bootloader | GRUB | README requires UEFI **and** BIOS; systemd-boot is UEFI-only; grub has the most docs | [004](decisions/004-bootloader.md) |
| 5 | AUR helper | yay | Established, documented, used by Omarchy reference | [005](decisions/005-aur-helper.md) |
| 6 | Default editor | `nano` (emergency) + `helix` (default) | Helix is batteries-included; no config needed to be functional; no LazyVim complexity | [006](decisions/006-default-editor.md) |
| 7 | Browser | None in core; `akula-install-browser` script | Firefox is ~500 MB RSS — violates the 50 MB rule; user opts in deliberately | [007](decisions/007-browser.md) |
