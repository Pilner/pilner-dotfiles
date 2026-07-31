#!/usr/bin/env bash

# macOS dotfiles installer.
set -euo pipefail

# Dynamically get the directory the script is in
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_SHELL="zsh"

# Source library modules (function definitions only, nothing executes)
# shellcheck source=lib/logging.sh
source "$SCRIPT_DIR/lib/logging.sh"
# shellcheck source=lib/platform.sh
source "$SCRIPT_DIR/lib/platform.sh"
# shellcheck source=lib/macos.sh
source "$SCRIPT_DIR/lib/macos.sh"
# shellcheck source=lib/shell.sh
source "$SCRIPT_DIR/lib/shell.sh"
# shellcheck source=lib/stow.sh
source "$SCRIPT_DIR/lib/stow.sh"

usage() {
  cat <<'EOF'
Usage: ./main.sh [options] [shell]

Options:
  -s, --symlink-update   Only update GNU Stow symlinks
  -u, --unstow           Remove symlinks (run this before git pull)
  -h, --help             Show this help message

Shells:
  zsh (default), bash
EOF
}

main() {
  local shell_choice="$DEFAULT_SHELL"
  local symlink_only=false
  local remove_only=false

  require_supported_os

  # Parse arguments
  while [[ "$#" -gt 0 ]]; do
    case "$1" in
      -s|--symlink-update)
        symlink_only=true
        ;;
      -u|--unstow)
        remove_only=true
        ;;
      bash|zsh)
        shell_choice="$1"
        ;;
      -h|--help)
        usage
        return 0
        ;;
      *)
        log_warn "Unknown argument: $1. Ignoring."
        ;;
    esac
    shift
  done

  echo -e "${GREEN}Starting Pilner's dotfiles setup!${NC}\n"

  # Execute Unstow-Only path
  if [[ "$remove_only" == true ]]; then
    log_info "Running in unstow-only mode..."
    remove_symlinks "$shell_choice"
    echo -e "\n${GREEN}Symlinks removed successfully! You can now safely run git pull.${NC}"
    return 0
  fi

  # Execute Symlink-Only path
  if [[ "$symlink_only" == true ]]; then
    log_info "Running in symlink-only mode..."
    create_symlinks "$shell_choice"
    echo -e "\n${GREEN}Symlinks updated successfully!${NC}"
    return 0
  fi

  # Execute Standard path
  create_symlinks "$shell_choice"
  setup_shell "$shell_choice"
  setup_macos

  echo -e "\n${GREEN}Installation complete! Please restart your terminal.${NC}"
}

main "$@"
