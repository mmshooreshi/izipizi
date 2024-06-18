#!/bin/bash

# Constants
REPO_URL="https://raw.githubusercontent.com/mmshooreshi/izipizi/main/bookmarkd.sh"
TARGET_DIR="$HOME/.izipizi"
SCRIPT_PATH="$TARGET_DIR/bookmarkd.sh"

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Functions
create_target_dir() {
  mkdir -p "$TARGET_DIR"
}

download_script() {
  if curl -o "$SCRIPT_PATH" "$REPO_URL"; then
    echo -e "${BLUE}Succesfully, downloaded the script from $REPO_URL${NC}"
    chmod +x "$SCRIPT_PATH"
  else
    echo -e "${RED}Failed to download script from $REPO_URL${NC}"
    exit 1
  fi
}

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
      echo -e "${RED}Unsupported shell: $shell_name. Please add 'source $SCRIPT_PATH' to your shell configuration manually.${NC}"
      exit 1
      ;;
  esac
}

add_source_command() {
  local shell_config=$1
  echo -e "${BLUE} script path --> $SCRIPT_PATH must be added to --> $shell_config ...${NC}"

  if ! grep -Fxq "source $SCRIPT_PATH" "$shell_config"; then
    echo "" >> "$shell_config"
    echo "source $SCRIPT_PATH" >> "$shell_config"
    echo -e "${GREEN}Bookmark script installed. Please restart your terminal or run 'source $shell_config'.${NC}"
  else
    echo -e "${YELLOW}Bookmark script already installed.${NC}"
  fi
}

main() {
  create_target_dir
  download_script
  local shell_config=$(detect_shell_config)
  echo -e "${BLUE}Adding \`source bookmarkd.sh\` to $shell_config ...${NC}"
  add_source_command "$shell_config"
}

# Execute the main function
main
