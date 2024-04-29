#!/bin/zsh
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

HOME="$(realpath ~)"
NVIM_HOME="$HOME/.config/nvim"
NVIM_CACHE="$HOME/.local/share/nvim"
ROOT=$(realpath ../)
CONFIG=$(realpath ./config)
NVCHAD="$ROOT/NvChad"
CUSTON="$NVCHAD/lua/custom"

# This script WILL NOT remove the following:
# XCode Command Line Tools
# Homebrew
# NVM
# Node
# Any repos installed into $DOTFILES
# Git Configs
#
# This script WILL remove the following:
# Prezto and configs
# symlinks in $HOME


remove_symlink () {
  # The symlink to remove
  local link=$1

  if [[ -e $link ]]; then
    if [[ -L $link ]]; then
      echo "🧹 removing ${GREEN}${link}${NC}"
      rm $link

      if [ -d ${link}.backup ]; then
        echo "📦 Restoring ${link}.backup"
        mv ${link}.backup ${link}
      fi
    else
      echo "⛔️ ${RED}${link}${NC} exists but is not a link. Skipping"
    fi
  fi
}

remove_symlinks_matching_glob () {
  local glob=$1

  for FILE in $glob; do
    # if the glob failed to return any files, skip
    if [ ! -e "$FILE" ]
    then
      echo "${RED}No files match ${glob}${NC}"
      continue
    fi

    remove_symlink $FILE
  done
}

declare -a links=("$HOME/.zprezto"
  "$HOME/.zsh.prompts"
  "$HOME/.zsh.before"
  "$HOME/.zsh.after"
  "$HOME/.zsh"
  "$HOME/.config/neovide"
  "$ROOT/NVChad/lua/custom"
  "$ROOT/NVChad/after"
  "$HOME/.config/nvim"
  "$NVIM_HOME"
)

for i in "${links[@]}"
do
  remove_symlink "$i"
done

# Remove the nvim compiled code/cache
if [ -d $NVIM_CACHE ]
then
  echo "🧹 removing Nvim cache files"
  rm -rf $NVIM_CACHE
fi

# Remove Prezto configs
echo "Removing Prezto Configs"
setopt EXTENDED_GLOB
for rcfile in $ROOT/prezto/runcoms/^README.md(.N); do
  remove_symlink "${HOME}/.${rcfile:t}" 
done
