#!/bin/bash
# Migration template — copy and rename for each new migration.
# Naming: NNN-short-description.sh  (NNN = zero-padded number)
#
# Rules:
#   - Idempotent: safe to run more than once.
#   - One concern per migration.
#   - Never modify data, only config and packages.

set -euo pipefail

MIGRATION_ID="000-template"
MARKER="${XDG_STATE_HOME:-$HOME/.local/state}/akula/migrations/$MIGRATION_ID"

if [[ -f "$MARKER" ]]; then
    echo "$MIGRATION_ID: already applied, skipping."
    exit 0
fi

echo "Applying $MIGRATION_ID..."

# ── Migration steps ───────────────────────────────────────────────────────────

# TODO: replace with actual migration steps

# ── Mark applied ──────────────────────────────────────────────────────────────

mkdir -p "$(dirname "$MARKER")"
date --iso-8601=seconds > "$MARKER"
echo "$MIGRATION_ID: done."
