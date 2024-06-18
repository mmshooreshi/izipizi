#!/bin/bash

# File to store bookmarks and notes
BOOKMARKS_FILE="$HOME/.bookmarks"
NOTES_FILE="$HOME/.bookmarks_notes"

# Color definitions
define_colors() {
RED='\033[0;31m'
BRIGHT_RED='\033[1;31m'
DARK_RED='\033[0;31m'
BLINK_RED='\033[5;31m'
BOLD_RED='\033[1;31m'
BG_RED='\033[41m'

GREEN='\033[0;32m'
BRIGHT_GREEN='\033[1;32m'
DARK_GREEN='\033[0;32m'
BLINK_GREEN='\033[5;32m'
BOLD_GREEN='\033[1;32m'
BG_GREEN='\033[42m'

YELLOW='\033[0;33m'
BRIGHT_YELLOW='\033[1;33m'
DARK_YELLOW='\033[0;33m'
BLINK_YELLOW='\033[5;33m'
BOLD_YELLOW='\033[1;33m'
BG_YELLOW='\033[43m'

BLUE='\033[0;34m'
BRIGHT_BLUE='\033[1;34m'
DARK_BLUE='\033[0;34m'
BLINK_BLUE='\033[5;34m'
BOLD_BLUE='\033[1;34m'
BG_BLUE='\033[44m'

MAGENTA='\033[0;35m'
BRIGHT_MAGENTA='\033[1;35m'
DARK_MAGENTA='\033[0;35m'
BLINK_MAGENTA='\033[5;35m'
BOLD_MAGENTA='\033[1;35m'
BG_MAGENTA='\033[45m'

CYAN='\033[0;36m'
BRIGHT_CYAN='\033[1;36m'
DARK_CYAN='\033[0;36m'
BLINK_CYAN='\033[5;36m'
BOLD_CYAN='\033[1;36m'
BG_CYAN='\033[46m'

WHITE='\033[0;37m'
BRIGHT_WHITE='\033[1;37m'
DARK_WHITE='\033[0;37m'
BLINK_WHITE='\033[5;37m'
BOLD_WHITE='\033[1;37m'
BG_WHITE='\033[47m'

BLACK='\033[0;30m'
BRIGHT_BLACK='\033[1;30m'
DARK_BLACK='\033[0;30m'
BLINK_BLACK='\033[5;30m'
BOLD_BLACK='\033[1;30m'
BG_BLACK='\033[40m'

NC='\033[0m' # No Color
}

define_colors

# Ensure files exist
touch "$BOOKMARKS_FILE" "$NOTES_FILE"

# Show help message
bm_show_help() {
  echo -e "${BG_BLUE}${WHITE}Usage:${NC}"
  echo -e "${BG_YELLOW}${BLACK}Commands:${NC}"
  echo -e "  ${BG_GREEN}${BLACK}bm add <name>${NC}        Add a bookmark with the given name"
  echo -e "  ${BG_GREEN}${BLACK}bm delete <name>${NC}     Delete the bookmark with the given name"
  echo -e "  ${BG_GREEN}${BLACK}bm go <name>${NC}         Go to the directory of the bookmark with the given name"
  echo -e "  ${BG_GREEN}${BLACK}bm list${NC}              List all bookmarks"
  echo -e "  ${BG_GREEN}${BLACK}bm note <name> <note>${NC} Add a note to the bookmark with the given name"
  echo -e "  ${BG_GREEN}${BLACK}bm notes${NC}             List all notes"
  echo -e "  ${BG_GREEN}${BLACK}bm help${NC}              Show this help message"
  echo -e ""
  echo -e "${BG_YELLOW}${BLACK}Examples:${NC}"
  echo -e "  ${BG_GREEN}${BLACK}bm add project${NC}"
  echo -e "      Add a bookmark named 'project'."
  echo -e "  ${BG_GREEN}${BLACK}bm go project${NC}"
  echo -e "      Navigate to the directory of the bookmark named 'project'."
  echo -e "  ${BG_GREEN}${BLACK}bm list${NC}"
  echo -e "      List all bookmarks."
  echo -e "  ${BG_GREEN}${BLACK}bm note project \"Important note\"${NC}"
  echo -e "      Add a note to the bookmark named 'project'."
  echo -e "  ${BG_GREEN}${BLACK}bm notes${NC}"
  echo -e "      List all notes."
}

# Add a bookmark
bm_add() {
  if [ -z "$1" ]; then
    echo -e "${BG_RED}${WHITE}Bookmark name is required.${NC}"
    return 1
  fi
  if grep -q "^$1=" "$BOOKMARKS_FILE"; then
    echo -e "${BG_YELLOW}${BLACK}Bookmark '$1' already exists.${NC}"
  else
    echo "$1=$(pwd)" >> "$BOOKMARKS_FILE"
    echo -e "${BG_GREEN}${WHITE}Bookmark '$1' added.${NC}"
  fi
}

# Delete a bookmark
bm_delete() {
  if [ -z "$1" ]; then
    echo -e "${BG_RED}${WHITE}Bookmark name is required.${NC}"
    return 1
  fi
  if grep -q "^$1=" "$BOOKMARKS_FILE"; then
    sed -i "/^$1=/d" "$BOOKMARKS_FILE"
    sed -i "/^$1: /d" "$NOTES_FILE"
    echo -e "${BG_GREEN}${WHITE}Bookmark '$1' deleted.${NC}"
  else
    echo -e "${BG_RED}${WHITE}Bookmark '$1' not found.${NC}"
  fi
}

# Go to a bookmark
bm_go() {
  if [ -z "$1" ]; then
    echo -e "${BG_RED}${WHITE}Bookmark name is required.${NC}"
    return 1
  fi
  local DIR
  DIR=$(grep "^$1=" "$BOOKMARKS_FILE" | cut -d'=' -f2-)
  if [ -n "$DIR" ]; then
    cd "$DIR" || echo -e "${BG_RED}${WHITE}Failed to change directory to bookmark '$1'.${NC}"
  else
    echo -e "${BG_RED}${WHITE}Bookmark '$1' not found.${NC}"
  fi
}

# List all bookmarks
bm_list() {
  if [ -s "$BOOKMARKS_FILE" ]; then
    echo -e "${BG_YELLOW}${BLACK}Bookmarks:${NC}"
    while read -r line; do
      local NAME="${line%%=*}"
      local DIR="${line#*=}"
      echo -e "${BG_GREEN}${BLACK}${NAME}:${NC} ${BG_WHITE}${BLACK}${DIR}${NC}"
      # Display notes if any
      grep "^$NAME: " "$NOTES_FILE" | while read -r note; do
        echo -e "${BG_MAGENTA}${WHITE}  Note: ${NC}${MAGENTA}${note}${NC}"
      done
    done < "$BOOKMARKS_FILE"
  else
    echo -e "${BG_RED}${WHITE}No bookmarks found.${NC}"
  fi
}

# Add a note to a bookmark
bm_note() {
  if [ -z "$1" ] || [ -z "$2" ]; then
    echo -e "${BG_RED}${WHITE}Bookmark name and note are required.${NC}"
    return 1
  fi
  if grep -q "^$1=" "$BOOKMARKS_FILE"; then
    echo "$1: $2" >> "$NOTES_FILE"
    echo -e "${BG_GREEN}${WHITE}Note added to bookmark '$1'.${NC}"
  else
    echo -e "${BG_RED}${WHITE}Bookmark '$1' not found.${NC}"
  fi
}

# List all notes
bm_list_notes() {
  if [ -s "$NOTES_FILE" ]; then
    echo -e "${BG_YELLOW}${BLACK}Notes:${NC}"
    while read -r line; do
      echo -e "${BG_GREEN}${BLACK}$line${NC}"
    done < "$NOTES_FILE"
  else
    echo -e "${BG_RED}${WHITE}No notes found.${NC}"
  fi
}

# Main function to handle commands
bm() {
  case "$1" in
    help)
      bm_show_help
      ;;
    add)
      shift
      bm_add "$@"
      ;;
    delete)
      shift
      bm_delete "$@"
      ;;
    go)
      shift
      bm_go "$@"
      ;;
    list)
      bm_list
      ;;
    note)
      shift
      bm_note "$@"
      ;;
    notes)
      bm_list_notes
      ;;
    *)
      echo -e "${BG_RED}${WHITE}Invalid command: $1${NC}"
      bm_show_help
      return 1
      ;;
  esac
}

# Enable autocompletion for bookmark names
_bm_complete() {
  local cur="${COMP_WORDS[COMP_CWORD]}"
  COMPREPLY=( $(compgen -W "$(cut -d'=' -f1 "$BOOKMARKS_FILE")" -- "$cur") )
}

complete -F _bm_complete bm

# Ensure the script is executable
chmod +x "$0"

# Add the following line to your ~/.bashrc or ~/.zshrc to source the script
# source /path/to/this/bookmark.sh

bm_list