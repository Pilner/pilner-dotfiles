#!/usr/bin/env bash

# macOS-only implementations. main.sh calls setup_macos(), which bundles
# every macOS-specific step. This file only defines functions; it never
# executes anything on source.

os_stow_packages() {
  echo "shared macos"
}

ensure_brew_env() {
  # Safely evaluate Homebrew shellenv for both Apple Silicon and Intel Macs
  if [[ -x "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x "/usr/local/bin/brew" ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
}

install_packages() {
  log_info "Installing packages via Homebrew..."

  if ! command -v brew &> /dev/null; then
    log_info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  ensure_brew_env

  if [[ ! -f "$SCRIPT_DIR/packages/Brewfile" ]]; then
    die "Brewfile not found at $SCRIPT_DIR/packages/Brewfile"
  fi

  brew bundle --file="$SCRIPT_DIR/packages/Brewfile"
}

install_font() {
  brew install --cask "font-hack-nerd-font"
  log_info "Hack Nerd Font installed successfully."
}

setup_macbook_defaults() {
  log_info "Enhancing MacOS Experience..."
  defaults write com.apple.dock autohide-delay -float 0; killall Dock
  defaults write -g InitialKeyRepeat -int 20
  defaults write -g KeyRepeat -int 2
  defaults write -g ApplePressAndHoldEnabled -bool false
}

setup_macos() {
  log_info "Setting up macOS..."
  install_packages
  install_font
  setup_macbook_defaults
}
