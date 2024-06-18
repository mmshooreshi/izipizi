#!/bin/bash

# File to store bookmarks and notes
BOOKMARKS_FILE="$HOME/.bookmark0s"
NOTES_FILE="$HOME/.bookmark0s_notes"

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Ensure files exist
touch "$BOOKMARKS_FILE" "$NOTES_FILE"

# Functions
bm_show_help() {
  echo -e "${BLUE}Usage: bm [COMMAND] [ARGS]${NC}"
  echo -e "${YELLOW}Commands:${NC}"
  echo -e "  ${GREEN}bm_add <name>${NC}      Add a bookmark with the given name"
  echo -e "  ${GREEN}bm_go <name>${NC}      Go to the directory of the bookmark with the given name"
  echo -e "  ${GREEN}bm_list${NC}            List all bookmarks"
  echo -e "  ${GREEN}bm_note <name> <note>${NC} Add a note to the bookmark with the given name"
  echo -e "  ${GREEN}bm_list_notes${NC}      List all notes"
  echo -e "  ${GREEN}bm_help${NC}            Show this help message"
  echo -e ""
  echo -e "${YELLOW}Examples:${NC}"
  echo -e "  ${GREEN}bm add project${NC}"
  echo -e "      Add a bookmark named 'project'."
  echo -e "  ${GREEN}bm go project${NC}"
  echo -e "      Navigate to the directory of the bookmark named 'project'."
  echo -e "  ${GREEN}bm list${NC}"
  echo -e "      List all bookmarks."
  echo -e "  ${GREEN}bm note project \"Important note\"${NC}"
  echo -e "      Add a note to the bookmark named 'project'."
  echo -e "  ${GREEN}bm list_notes${NC}"
  echo -e "      List all notes."
}

bm_add() {
  if [ -z "$1" ]; then
    echo -e "${RED}Bookmark name is required.${NC}"
    return 1
  fi
  echo "$1=$(pwd)" >> "$BOOKMARKS_FILE"
  echo -e "${GREEN}Bookmark '$1' added.${NC}"
}

bm_go() {
  if [ -z "$1" ]; then
    echo -e "${RED}Bookmark name is required.${NC}"
    return 1
  fi
  local DIR
  DIR=$(grep "^$1=" "$BOOKMARKS_FILE" | cut -d'=' -f2-)
  if [ -n "$DIR" ]; then
    cd "$DIR" || echo -e "${RED}Failed to change directory to bookmark '$1'.${NC}"
  else
    echo -e "${RED}Bookmark '$1' not found.${NC}"
  fi
}

bm_list() {
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

bm_note() {
  if [ -z "$1" ] || [ -z "$2" ]; then
    echo -e "${RED}Bookmark name and note are required.${NC}"
    return 1
  fi
  echo "$1: $2" >> "$NOTES_FILE"
  echo -e "${GREEN}Note added to bookmark '$1'.${NC}"
}

bm_list_notes() {
  if [ -f "$NOTES_FILE" ]; then
    echo -e "${YELLOW}Notes:${NC}"
    cat "$NOTES_FILE" | while read -r line; do
      echo -e "${GREEN}$line${NC}"
    done
  else
    echo -e "${RED}No notes found.${NC}"
  fi
}

# Autocompletion for bookmark names
_bookmark_complete() {
  local cur=${COMP_WORDS[COMP_CWORD]}
  COMPREPLY=( $(compgen -W "$(cut -d'=' -f1 $BOOKMARKS_FILE)" -- $cur) )
}

complete -F _bookmark_complete bm_go bm_note

# Main
if [ $# -eq 0 ]; then
  bm_show_help
else
  case "$1" in
    help)
      bm_show_help
      ;;
    add)
      shift
      bm_add "$@"
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
    list_notes)
      bm_list_notes
      ;;
    *)
      echo -e "${RED}Invalid command: $1${NC}"
      bm_show_help
      exit 1
      ;;
  esac
fi
