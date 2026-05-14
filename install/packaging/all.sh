#!/bin/bash
set -euo pipefail

_d="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=install/packaging/00-pacman.sh
source "$_d/00-pacman.sh"

# shellcheck source=install/packaging/01-aur-helper.sh
source "$_d/01-aur-helper.sh"

# shellcheck source=install/packaging/02-base.sh
source "$_d/02-base.sh"

# shellcheck source=install/packaging/03-sway.sh
source "$_d/03-sway.sh"

# shellcheck source=install/packaging/04-audio.sh
source "$_d/04-audio.sh"

# shellcheck source=install/packaging/05-network.sh
source "$_d/05-network.sh"

# shellcheck source=install/packaging/06-fonts.sh
source "$_d/06-fonts.sh"

# shellcheck source=install/packaging/07-theming.sh
source "$_d/07-theming.sh"

# shellcheck source=install/packaging/08-terminal.sh
source "$_d/08-terminal.sh"
