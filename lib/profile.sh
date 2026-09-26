#!/usr/bin/env bash

# Profile management for dotfiles.
# This file only defines functions; it never executes anything on source.

# shellcheck source=lib/logging.sh
source "$(dirname "${BASH_SOURCE[0]}")/logging.sh"

PROFILE_FILE="$HOME/.config/dotfiles/profile.zsh"

set_active_profile() {
  local profile="${1:-personal}"
  mkdir -p "$(dirname "$PROFILE_FILE")"
  rm -f "$PROFILE_FILE"
  echo "export DOTFILES_PROFILE=$profile" > "$PROFILE_FILE"
  log_info "Active profile set to: $profile"
}

clear_active_profile() {
  rm -f "$PROFILE_FILE"
  log_info "Active profile cleared"
}

get_active_profile() {
  if [[ -f "$PROFILE_FILE" ]]; then
    grep -o 'DOTFILES_PROFILE=\w*' "$PROFILE_FILE" | cut -d= -f2
  else
    echo "personal"
  fi
}