---
title: 004 — Bootloader
date: 2026-05-14
status: decided
---

## Context

AkulaOS targets "UEFI or BIOS boot" (from README.md). The installer must handle both.
The bootloader choice affects: install complexity, dual-boot support, recovery options,
and how much documentation exists when things go wrong.

## Decision

**GRUB (grub package + grub-mkconfig).**

Install path (UEFI):
```bash
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=AkulaOS
grub-mkconfig -o /boot/grub/grub.cfg
```

Install path (BIOS/MBR):
```bash
grub-install --target=i386-pc /dev/sdX
grub-mkconfig -o /boot/grub/grub.cfg
```

The same `grub-mkconfig` command works for both. The install script detects UEFI vs BIOS
via `[ -d /sys/firmware/efi ]` and branches accordingly.

## Alternatives Considered

| Option | BIOS support | Notes |
|---|---|---|
| systemd-boot | No (UEFI only) | Simpler config, but breaks BIOS target from README |
| limine | Yes | Used by Omarchy; modern; less documentation for beginners |
| refind | Yes | Feature-rich; overkill; complex theming |
| **GRUB (chosen)** | **Yes** | Industry standard; every Arch guide; huge documentation base |

## Consequences

**Good:**
- GRUB is the single most documented bootloader for Arch Linux. Any error the user hits
  has a Stack Overflow answer.
- Handles UEFI + BIOS with one install path, branching only on the `grub-install` command.
- Dual-boot detection (`os-prober`) works out of the box.
- GRUB theme can be customized — future AkulaOS GRUB theme is possible.

**Bad:**
- GRUB config is verbose and generated (`grub-mkconfig`) — not human-editable in a clean way.
- Slower to boot than systemd-boot (negligible on modern SSDs).
- Limine (Omarchy's choice) is genuinely better architecturally, but the documentation gap
  matters more for v1.

**Note on limine:** If the user becomes comfortable and wants to switch, the decision should
be revisited. Limine's config is simpler and more readable. This decision is conservative,
not permanent.
