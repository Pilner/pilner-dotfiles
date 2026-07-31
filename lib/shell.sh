#!/usr/bin/env bash

# Generic shell setup (Oh-My-Zsh). OS-specific pieces live in the OS module.
# This file only defines functions; it never executes anything on source.

setup_shell() {
  local shell_choice="$1"

  if [[ "$shell_choice" == "zsh" ]]; then
    log_info "Setting up Oh-My-Zsh..."

    if ! command -v zsh &> /dev/null; then
      log_warn "Zsh is not installed. Skipping Oh-My-Zsh setup."
      return 1
    fi

    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
      KEEP_ZSHRC=yes CHSH=no RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
      log_info "Oh-My-Zsh installed successfully."
    else
      log_info "Oh-My-Zsh is already installed. Skipping base install."
    fi
  fi
}
