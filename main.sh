#!/bin/bash

# Cross-platform dotfiles installer
set -e

# Dynamically get the directory the script is in
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Helper functions
log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

detect_os() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "macos"
  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "linux"
  else
    echo "unknown"
  fi
}

setup_macbook() {
  log_info "Enhancing MacOS Experience..."
  defaults write com.apple.dock autohide-delay -float 0; killall Dock
  defaults write -g InitialKeyRepeat -int 20
  defaults write -g KeyRepeat -int 2
  defaults write -g ApplePressAndHoldEnabled -bool false
}

install_packages() {
  local os=$(detect_os)

  case "$os" in
    "macos")
      log_info "Detected OS: macOS"

      # Check if Homebrew is installed, install if not
      if ! command -v brew &> /dev/null; then
        log_info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      fi

      # Safely evaluate Homebrew shellenv for both Apple Silicon and Intel Macs
      if [[ -x "/opt/homebrew/bin/brew" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
      elif [[ -x "/usr/local/bin/brew" ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
      fi

      # Verify Brewfile exists before running
      if ! [[ -f "$DOTFILES_DIR/packages/Brewfile" ]]; then
        log_error "Brewfile not found at $DOTFILES_DIR/packages/Brewfile"
        exit 1
      fi

      log_info "Installing packages via Homebrew..."
      brew bundle --file="$DOTFILES_DIR/packages/Brewfile"
      ;;

    "linux")
      # Verify if packages.linux exists before proceeding
      if [[ ! -f "$DOTFILES_DIR/packages/packages.linux" ]]; then
        log_error "Package list not found at $DOTFILES_DIR/packages/packages.linux"
        exit 1
      fi

      if [ -f /etc/arch-release ]; then
        log_info "Detected OS: Arch Linux"
        log_info "Installing packages..."
        sudo pacman -Syu --needed $(grep -v '^#' "$DOTFILES_DIR/packages/packages.linux" | tr '\n' ' ')

      elif command -v apt-get &> /dev/null; then
        log_info "Detected OS: Ubuntu/Debian"
        log_info "Installing packages..."
        sudo apt-get update
        sudo apt-get install -y $(grep -v '^#' "$DOTFILES_DIR/packages/packages.linux" | tr '\n' ' ')

      else
        log_error "Unsupported Linux Distro. Please install packages manually!"
        exit 1
      fi
      ;;

    *)
      log_error "Unknown or unsupported Operating System."
      exit 1
      ;;
  esac
}

create_symlinks() {
  local os=$(detect_os)
  local shell_choice="${1:-zsh}" # Default to zsh

  log_info "Creating symlinks with GNU Stow..."

  # Navigate to the dynamic dotfiles directory
  cd "$DOTFILES_DIR" || exit

  # Make sure stow is actually installed before trying to run it
  if ! command -v stow &> /dev/null; then
    log_error "GNU Stow is not installed! Cannot create symlinks."
    exit 1
  fi

  log_info "Setting up config files..."
  stow -t "$HOME" -R config_files

  # Stow shell-specific package
  if [[ "$shell_choice" == "bash" ]]; then
    log_info "Setting up bash configuration..."
    stow -t "$HOME" -R bash
  else
    log_info "Setting up zsh configuration..."
    stow -t "$HOME" -R zsh
  fi

  mkdir -p ~/.config

  if [[ "$os" == "macos" ]]; then
    # Safely evaluate Homebrew shellenv for both Apple Silicon and Intel Macs
    if [[ -x "/opt/homebrew/bin/brew" ]]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -x "/usr/local/bin/brew" ]]; then
      eval "$(/usr/local/bin/brew shellenv)"
    fi
  fi
}

setup_shell() {
  local os=$(detect_os)
  local shell_choice="${1:-zsh}"

  if [[ "$shell_choice" == "zsh" ]]; then
    log_info "Setting up Oh-My-Zsh..."

    # Ensure zsh is installed before attempting Oh-My-Zsh setup
    if ! command -v zsh &> /dev/null; then
      log_warn "Zsh is not installed. Skipping Oh-My-Zsh setup."
      return 1
    fi

    # Only install if OMZ directory doesn't already exist
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
      KEEP_ZSHRC=yes CHSH=no RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
      log_info "Oh-My-Zsh installed successfully."
    else
      log_info "Oh-My-Zsh is already installed. Skipping base install."
    fi

    # Handle the custom themes (runs whether OMZ was just installed or already existed)
    if [[ -d "$DOTFILES_DIR/zsh_themes" ]]; then
      log_info "Copying custom Zsh themes..."

      # Ensure the custom themes directory exists
      mkdir -p "$HOME/.oh-my-zsh/custom/themes"

      # TODO: convert this into using stow
      # Copy all files from the zsh_themes directory to the OMZ custom themes folder
      # Using cp -a preserves permissions, and we suppress errors if the folder is empty
      cp -a "$DOTFILES_DIR/zsh_themes/"* "$HOME/.oh-my-zsh/custom/themes/" 2>/dev/null || log_warn "No themes found to copy."
    else
      log_warn "Theme directory not found at $DOTFILES_DIR/zsh_themes. Skipping themes."
    fi

    # Install Nerd Hack Font
    if [[ "$os" == "macos" ]]; then
      brew install --cask "font-hack-nerd-font"
      log_info "Hack Nerd Font installed successfully."
    elif [[ "$os" == "linux" ]]; then
      local FONT_DIR="$HOME/.local/share/fonts/HackNerd"

      if [[ ! -d "$FONT_DIR" ]]; then
        log_info "Downloading and installing Hack Nerd Font..."
        mkdir -p "$FONT_DIR"

        # Download the latest Hack.zip from the official repository
        wget -qO /tmp/Hack.zip "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.zip"

        # Unzip and clean up
        unzip -q /tmp/Hack.zip -d "$FONT_DIR"
        rm /tmp/Hack.zip

        # Rebuild the font cache so the terminal can see it
        fc-cache -fv
        log_info "Hack Nerd Font installed successfully."
      else
        log_info "Hack Nerd Font is already installed."
      fi
    fi

  fi
}

remove_symlinks() {
  local shell_choice="${1:-zsh}" # Default to zsh

  log_info "Removing symlinks with GNU Stow..."

  # Navigate to the dynamic dotfiles directory
  cd "$DOTFILES_DIR" || exit

  # Make sure stow is actually installed before trying to run it
  if ! command -v stow &> /dev/null; then
    log_error "GNU Stow is not installed! Cannot remove symlinks."
    exit 1
  fi

  log_info "Removing config files..."
  stow -t "$HOME" -D config_files

  # Unstow shell-specific package
  if [[ "$shell_choice" == "bash" ]]; then
    log_info "Removing bash configuration..."
    stow -t "$HOME" -D bash
  else
    log_info "Removing zsh configuration..."
    stow -t "$HOME" -D zsh
  fi
}

# Main Function
main() {
  # Default values
  local shell_choice="zsh"
  local symlink_only=false
  local remove_only=false

  # Parse arguments
  while [[ "$#" -gt 0 ]]; do
    case $1 in
      -s|--symlink-update)
        symlink_only=true
        ;;
      -u|--unstow)
        remove_only=true
        ;;
      bash)
        shell_choice="bash"
        ;;
      zsh)
        shell_choice="zsh"
        ;;
      -h|--help)
        echo "Usage: ./main.sh [options] [shell]"
        echo "Options:"
        echo "  -s, --symlink-update   Only update GNU Stow symlinks"
        echo "  -u, --unstow           Remove symlinks (run this before git pull)"
        echo "  -h, --help             Show this help message"
        echo "Shells:"
        echo "  zsh (default), bash"
        return 0
        ;;
      *)
        log_warn "Unknown argument: $1. Ignoring."
        ;;
    esac
    shift # Move to the next argument
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
  install_packages
  create_symlinks "$shell_choice"
  setup_shell "$shell_choice"

  if [[ $(detect_os) == "macos" ]]; then
    setup_macbook
  fi

  echo -e "\n${GREEN}Installation complete! Please restart your terminal.${NC}"
}

main "$@"
