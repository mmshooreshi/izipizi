#!/bin/bash

# File to store bookmarks and notes
BOOKMARKS_FILE="$HOME/.bookmarks"
NOTES_FILE="$HOME/.bookmarks_notes"

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Add bookmark
bm() {
  echo "$1=$(pwd)" >> "$BOOKMARKS_FILE"
  echo -e "${GREEN}Bookmark '$1' added.${NC}"
}

# Go to bookmark
g0() {
  local DIR
  DIR=$(grep "^$1=" "$BOOKMARKS_FILE" | cut -d'=' -f2-)
  if [ -n "$DIR" ]; then
    cd "$DIR" || echo -e "${RED}Failed to change directory to bookmark '$1'.${NC}"
  else
    echo -e "${RED}Bookmark '$1' not found.${NC}"
  fi
}

# List bookmarks
bl() {
  if [ -f "$BOOKMARKS_FILE" ]; then
    echo -e "${YELLOW}Bookmarks:${NC}"
    while read -r line; do
      echo -e "${GREEN}${line//=/: }${NC}"
      # Display notes if any
      grep "^${line//=/: }" "$NOTES_FILE" 2>/dev/null | sed 's/^/  Note: /'
    done < "$BOOKMARKS_FILE"
  else
    echo -e "${RED}No bookmarks found.${NC}"
  fi
}

# Add note to bookmark
bn() {
  echo "$1: $2" >> "$NOTES_FILE"
  echo -e "${GREEN}Note added to bookmark '$1'.${NC}"
}

# List notes
ln() {
  if [ -f "$NOTES_FILE" ]; then
    echo -e "${YELLOW}Notes:${NC}"
    cat "$NOTES_FILE" | while read -r line; do
      echo -e "${GREEN}$line${NC}"
    done
  else
    echo -e "${RED}No notes found.${NC}"
  fi
}

# Save bookmarks and notes to file
save_bookmarks() {
  declare -p BOOKMARKS > "$BOOKMARKS_FILE"
}

# Load bookmarks from file
load_bookmarks() {
  if [ -f "$BOOKMARKS_FILE" ]; then
    eval $(cat "$BOOKMARKS_FILE")
  fi
}

# Load bookmarks on shell startup
load_bookmarks

# Save bookmarks on shell exit
trap save_bookmarks EXIT
