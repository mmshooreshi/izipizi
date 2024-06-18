#!/bin/bash

# Constants
TARGET_DIR="$HOME/.izipizi"
SCRIPT_PATH="$TARGET_DIR/bookmarkd.sh"

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Functions
detect_shell_config() {
  local shell_name=$(basename "$SHELL")
  case "$shell_name" in
    zsh)
      echo "$HOME/.zshrc"
      ;;
    bash)
      echo "$HOME/.bashrc"
      ;;
    *)
      echo -e "${RED}Unsupported shell: $shell_name. Please remove 'source $SCRIPT_PATH' from your shell configuration manually.${NC}"
      exit 1
      ;;
  esac
}

remove_source_command() {
  local shell_config=$1
  if grep -Fxq "source $SCRIPT_PATH" "$shell_config"; then
    sed -i "" "\|source $SCRIPT_PATH|d" "$shell_config"
    echo -e "${GREEN}Removed source command from $shell_config.${NC}"
  else
    echo -e "${YELLOW}Source command not found in $shell_config.${NC}"
  fi
}

uninstall_script() {
  local shell_config=$1
  remove_source_command "$shell_config"
  if [ -f "$SCRIPT_PATH" ]; then
    rm -f "$SCRIPT_PATH"
    echo -e "${GREEN}Bookmark script uninstalled.${NC}"
  else
    echo -e "${YELLOW}Bookmark script not found.${NC}"
  fi
  if [ -d "$TARGET_DIR" ]; then
    rmdir "$TARGET_DIR"
  fi
}

main() {
  local shell_config=$(detect_shell_config)
  uninstall_script "$shell_config"
}

# Execute the main function
main
