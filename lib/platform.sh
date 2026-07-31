#!/usr/bin/env bash

# OS detection and platform guard.
# This file only defines functions; it never executes anything on source.

detect_os() {
  case "$OSTYPE" in
    darwin*) echo "macos" ;;
    linux*)  echo "linux" ;;
    *)       echo "unknown" ;;
  esac
}

require_supported_os() {
  case "$(detect_os)" in
    macos) return 0 ;;
    *)
      die "This repo currently supports macOS only. Detected: $(detect_os)"
      ;;
  esac
}
