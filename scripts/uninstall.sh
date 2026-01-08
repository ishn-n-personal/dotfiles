#!/usr/bin/env bash
set -euo pipefail

# ─────────────────────────────────────────────
# Setup
# ─────────────────────────────────────────────

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG_DIR="$HOME/.config"
BACKUP_ROOT="$HOME/.dotfiles-backup"

echo
echo "Uninstalling dotfiles"
echo "Source: $DOTFILES_DIR"
echo

# macOS guard
if [[ "$(uname)" != "Darwin" ]]; then
  echo "Error: This setup is intended for macOS only."
  exit 1
fi

# ─────────────────────────────────────────────
# Helpers
# ─────────────────────────────────────────────

remove_symlink() {
  local target="$1"

  if [[ -L "$target" ]]; then
    echo "Removing symlink: $target"
    rm "$target"
  else
    echo "Skipping (not a symlink): $target"
  fi
}

restore_latest_backup() {
  if [[ ! -d "$BACKUP_ROOT" ]]; then
    echo "No backup directory found. Nothing to restore."
    return
  fi

  local latest_backup
  latest_backup="$(ls -1 "$BACKUP_ROOT" 2>/dev/null | sort | tail -n 1 || true)"

  if [[ -z "$latest_backup" ]]; then
    echo "No backups found. Nothing to restore."
    return
  fi

  local backup_path="$BACKUP_ROOT/$latest_backup"

  if [[ ! -d "$backup_path" || -z "$(ls -A "$backup_path" 2>/dev/null)" ]]; then
    echo "Latest backup is empty. Nothing to restore."
    return
  fi

  echo
  read -r -p "Restore latest backup from $latest_backup? [y/N]: " confirm
  if [[ "$confirm" =~ ^[Yy]$ ]]; then
    echo "Restoring backup..."
    cp -a "$backup_path"/. "$HOME"/
    echo "Backup restored."
  else
    echo "Backup restore skipped."
  fi
}

# ─────────────────────────────────────────────
# Remove symlinks (ONLY what install.sh creates)
# ─────────────────────────────────────────────

remove_symlink "$HOME/.zshrc"
remove_symlink "$HOME/.zprofile"

remove_symlink "$HOME/.yabairc"
remove_symlink "$HOME/.skhdrc"

remove_symlink "$HOME/.bordersrc"

remove_symlink "$CONFIG_DIR/ghostty"
remove_symlink "$CONFIG_DIR/neofetch"
remove_symlink "$CONFIG_DIR/sketchybar"
remove_symlink "$CONFIG_DIR/starship"
remove_symlink "$CONFIG_DIR/tmux"

# ─────────────────────────────────────────────
# Restore backups (optional)
# ─────────────────────────────────────────────

restore_latest_backup

# ─────────────────────────────────────────────
# Done
# ─────────────────────────────────────────────

echo
echo "Dotfiles uninstalled successfully."
echo "System returned to previous state where possible."
echo
