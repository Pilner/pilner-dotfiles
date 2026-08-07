#!/usr/bin/env bash

# Symlink management with GNU Stow, including shell-specific packages.
# OS-specific package lists come from the OS module via os_stow_packages().
# This file only defines functions; it never executes anything on source.

CONFIG_STOW_DIR="$SCRIPT_DIR/config_files"

ensure_stow() {
  if ! command -v stow &> /dev/null; then
    die "GNU Stow is not installed! Cannot manage symlinks."
  fi
}

ensure_config_dir() {
  # Ensure ~/.config is a real directory so Stow descends into it and links
  # leaf configs, instead of folding the whole .config into a single symlink
  # (which would conflict across packages like shared + macos sharing ~/.config).
  #
  # If ~/.config is a repo-owned symlink (from an older whole-dir setup),
  # replace it with a real directory.
  if [[ -L "$HOME/.config" ]]; then
    local resolved
    resolved="$(perl -MCwd -e 'print Cwd::abs_path($ARGV[0])' "$HOME/.config")"
    if [[ "$resolved" == "$SCRIPT_DIR"* ]]; then
      log_warn "Replacing repo-owned ~/.config symlink with a real directory."
      rm "$HOME/.config"
    else
      die "~/.config is a symlink to $resolved. Refusing to replace it; move it aside manually."
    fi
  fi
  mkdir -p "$HOME/.config"
}

stow_shell() {
  local shell_choice="$1"

  case "$shell_choice" in
    zsh)
      log_info "Setting up zsh configuration..."
      stow -t "$HOME" -R zsh

      # Handle the custom themes (runs whether OMZ was just installed or already existed)
      if [[ -d "$SCRIPT_DIR/zsh_themes" ]]; then
        log_info "Linking custom Zsh themes..."

        # Ensure the custom themes directory exists before stowing into it
        mkdir -p "$HOME/.oh-my-zsh/custom/themes"

        # Stow the theme files as symlinks so repo changes apply immediately
        stow -t "$HOME/.oh-my-zsh/custom/themes" -R zsh_themes
      else
        log_warn "Theme directory not found at $SCRIPT_DIR/zsh_themes. Skipping themes."
      fi
      ;;
    bash)
      log_info "Setting up bash configuration..."
      stow -t "$HOME" -R bash
      ;;
    *)
      die "Unsupported shell: $shell_choice"
      ;;
  esac
}

unstow_shell() {
  local shell_choice="$1"

  case "$shell_choice" in
    zsh)
      log_info "Removing zsh configuration..."
      stow -t "$HOME" -D zsh

      # Unstow custom themes (guard against missing OMZ install on bare git pull)
      if [[ -d "$HOME/.oh-my-zsh/custom/themes" ]]; then
        log_info "Removing custom Zsh themes..."
        stow -d "$SCRIPT_DIR" -t "$HOME/.oh-my-zsh/custom/themes" -D zsh_themes
      fi
      ;;
    bash)
      log_info "Removing bash configuration..."
      stow -t "$HOME" -D bash
      ;;
    *)
      die "Unsupported shell: $shell_choice"
      ;;
  esac
}

create_symlinks() {
  local shell_choice="$1"

  log_info "Creating symlinks with GNU Stow..."
  ensure_stow

  cd "$SCRIPT_DIR" || die "Could not change directory to $SCRIPT_DIR"

  ensure_config_dir

  for pkg in $(os_stow_packages); do
    if [[ ! -d "$CONFIG_STOW_DIR/$pkg" ]]; then
      log_warn "Skipping $pkg configs: package not present in repo."
      continue
    fi
    log_info "Stowing $pkg configs..."
    stow -d "$CONFIG_STOW_DIR" -t "$HOME" -R "$pkg"
  done

  stow_shell "$shell_choice"
}

remove_symlinks() {
  local shell_choice="$1"

  log_info "Removing symlinks with GNU Stow..."
  ensure_stow

  cd "$SCRIPT_DIR" || die "Could not change directory to $SCRIPT_DIR"

  for pkg in $(os_stow_packages); do
    if [[ ! -d "$CONFIG_STOW_DIR/$pkg" ]]; then
      log_warn "Skipping $pkg configs: package not present in repo."
      continue
    fi
    log_info "Removing $pkg configs..."
    stow -d "$CONFIG_STOW_DIR" -t "$HOME" -D "$pkg"
  done

  unstow_shell "$shell_choice"
}
