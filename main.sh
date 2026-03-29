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
      if [[ -f "$DOTFILES_DIR/packages/Brewfile" ]]; then
        log_info "Installing packages via Homebrew..."
        brew bundle --file="$DOTFILES_DIR/packages/Brewfile"
      else
        log_warn "Brewfile not found at $DOTFILES_DIR/packages/Brewfile"
      fi
      ;;

    "linux")
      if [ -f /etc/arch-release ]; then
        log_info "Detected OS: Arch Linux"
        log_info "Installing packages..."
        sudo pacman -Syu --needed $(cat "$DOTFILES_DIR/packages/packages.linux" | grep -v '^#' | tr '\n' ' ')

      elif command -v apt-get &> /dev/null; then
        log_info "Detected OS: Ubuntu/Debian"
        sudo apt-get update
        sudo apt-get install -y $(cat "$DOTFILES_DIR/packages/packages.linux" | grep -v '^#' | tr '\n' ' ')

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
  local shell_choice="${1:-zsh}" # Default to zsh

  log_info "Creating symlinks with GNU Stow..."
  
  # Navigate to the dynamic dotfiles directory
  cd "$DOTFILES_DIR" || exit

  # Make sure stow is actually installed before trying to run it
  if ! command -v stow &> /dev/null; then
    log_error "GNU Stow is not installed! Cannot create symlinks."
    exit 1
  fi

  stow config_files

  # Stow shell-specific package
  if [[ "$shell_choice" == "bash" ]]; then
    log_info "Setting up bash configuration..."
    stow bash
  else
    log_info "Setting up zsh configuration..."
    stow zsh
  fi
}

setup_shell() {
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
      
      # Copy all files from the zsh_themes directory to the OMZ custom themes folder
      # Using cp -a preserves permissions, and we suppress errors if the folder is empty
      cp -a "$DOTFILES_DIR/zsh_themes/"* "$HOME/.oh-my-zsh/custom/themes/" 2>/dev/null || log_warn "No themes found to copy."
    else
      log_warn "Theme directory not found at $DOTFILES_DIR/zsh_themes. Skipping themes."
    fi

  fi
}

# Main Function
main() {
  echo -e "${GREEN}Starting Pilner's dotfiles setup!${NC}\n"

  local shell_choice="${1:-zsh}"

  install_packages
  create_symlinks "$shell_choice"
  setup_shell "$shell_choice"

  echo -e "\n${GREEN}Installation complete! Please restart your terminal.${NC}"
}

main "$@"
