#!/bin/bash
# Sourced by install.sh before any stage runs.

_RED=$(tput setaf 1 2>/dev/null || printf '')
_GRN=$(tput setaf 2 2>/dev/null || printf '')
_YLW=$(tput setaf 3 2>/dev/null || printf '')
_BLU=$(tput setaf 4 2>/dev/null || printf '')
_RST=$(tput sgr0    2>/dev/null || printf '')

info()  { printf '%s==>%s %s\n'   "$_BLU" "$_RST" "$*"; }
ok()    { printf '%s  ok%s %s\n'  "$_GRN" "$_RST" "$*"; }
warn()  { printf '%swarn%s %s\n'  "$_YLW" "$_RST" "$*"; }
fail()  { printf '%sfail%s %s\n'  "$_RED" "$_RST" "$*" >&2; exit 1; }

pkg_install() {
    sudo pacman -S --needed --noconfirm "$@"
}

aur_install() {
    yay -S --needed --noconfirm "$@"
}

cmd_exists() {
    command -v "$1" &>/dev/null
}
