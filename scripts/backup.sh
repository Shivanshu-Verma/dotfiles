#!/usr/bin/env bash
# backup.sh — copy a path into a timestamped backup dir before it's replaced.
# Usage: backup.sh <path> [<path> ...]
# Backups go to ~/.dotfiles-backups/<timestamp>/ preserving the basename.
set -euo pipefail

STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_DIR="${HOME}/.dotfiles-backups/${STAMP}"

backed_up=0
for target in "$@"; do
  # Only back up real files/dirs — skip symlinks (they're ours) and missing.
  if [[ -e "$target" && ! -L "$target" ]]; then
    mkdir -p "$BACKUP_DIR"
    cp -a "$target" "$BACKUP_DIR/"
    echo "  backed up: $target -> $BACKUP_DIR/"
    backed_up=1
  fi
done

[[ "$backed_up" -eq 1 ]] && echo "  backup dir: $BACKUP_DIR"
exit 0
