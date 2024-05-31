#!/bin/bash

# URL of the bookmarkd.sh script in your GitHub repository
REPO_URL="https://raw.githubusercontent.com/mmshooreshi/izipizi/main/bookmarkd.sh"
TARGET_DIR="$HOME/.dir-bookmarks"

# Create target directory
mkdir -p "$TARGET_DIR"

# Download bookmarkd.sh script
curl -o "$TARGET_DIR/bookmarkd.sh" "$REPO_URL"
chmod +x "$TARGET_DIR/bookmarkd.sh"

# Determine the user's shell and the corresponding configuration file
if [ -n "$ZSH_VERSION" ]; then
  SHELL_CONFIG="$HOME/.zshrc"
elif [ -n "$BASH_VERSION" ]; then
  SHELL_CONFIG="$HOME/.bashrc"
else
  SHELL=$(basename "$SHELL")
  case "$SHELL" in
    zsh)
      SHELL_CONFIG="$HOME/.zshrc"
      ;;
    bash)
      SHELL_CONFIG="$HOME/.bashrc"
      ;;
    *)
      echo "Unsupported shell. Please add 'source $TARGET_DIR/bookmarkd.sh' to your shell configuration manually."
      exit 1
      ;;
  esac
fi

# Add source command to the shell configuration file if not already present
if ! grep -Fxq "source $TARGET_DIR/bookmarkd.sh" "$SHELL_CONFIG"; then
  echo "source $TARGET_DIR/bookmarkd.sh" >> "$SHELL_CONFIG"
  echo "Bookmark script installed. Please restart your terminal or run 'source $SHELL_CONFIG'."
else
  echo "Bookmark script already installed."
fi
