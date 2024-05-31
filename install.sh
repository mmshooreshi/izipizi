#!/bin/bash

# URL of the bookmark.sh script in your GitHub repository
REPO_URL="https://raw.githubusercontent.com/mmshooreshi/izipizi/main/bookmarkd.sh"
TARGET_DIR="$HOME/.izipizi"

# Create target directory
mkdir -p "$TARGET_DIR"

# Download bookmark.sh script
curl -o "$TARGET_DIR/bookmarkd.sh" "$REPO_URL"
chmod +x "$TARGET_DIR/bookmarkd.sh"

# Add source command to shell configuration file
if [ -n "$ZSH_VERSION" ]; then
  SHELL_CONFIG="$HOME/.zshrc"
elif [ -n "$BASH_VERSION" ]; then
  SHELL_CONFIG="$HOME/.bashrc"
else
  echo "Unsupported shell. Please add 'source $TARGET_DIR/bookmarkd.sh' to your shell configuration manually."
  exit 1
fi

if ! grep -Fxq "source $TARGET_DIR/bookmarkd.sh" "$SHELL_CONFIG"; then
  echo "source $TARGET_DIR/bookmarkd.sh" >> "$SHELL_CONFIG"
  echo "Bookmark script installed. Please restart your terminal or run 'source $SHELL_CONFIG'."
else
  echo "Bookmark script already installed."
fi

