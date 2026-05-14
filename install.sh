#!/bin/bash
set -euo pipefail

AKULA_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=install/helpers/all.sh
source "$AKULA_DIR/install/helpers/all.sh"

info "AkulaOS installer starting"
info "User: $(whoami)  Kernel: $(uname -r)"

# shellcheck source=install/preflight/all.sh
source "$AKULA_DIR/install/preflight/all.sh"

# shellcheck source=install/packaging/all.sh
source "$AKULA_DIR/install/packaging/all.sh"

# shellcheck source=install/config/all.sh
source "$AKULA_DIR/install/config/all.sh"

# shellcheck source=install/login/all.sh
source "$AKULA_DIR/install/login/all.sh"

# shellcheck source=install/post-install/all.sh
source "$AKULA_DIR/install/post-install/all.sh"
