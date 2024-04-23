#!/bin/sh

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

# Remove the custom folder symlined into the NvChad folder
if [ -L "$CUSTOM" ]
then
  echo "🧹 removing nvchad-config link"
  rm $ROOT/NVChad/lua/custom
else
  echo "✅ ${GREEN}NvChad/lua/custom${NC} not linked"
fi

# Remove the nvim compiled code/cache
if [ -d $NVIM_CACHE ]
then
  echo "🧹 removing Nvim cache files"
  rm -rf $NVIM_CACHE
fi

# Remove the ~/.config/nvim symlink to NvChad and restore any backups
if [ -L $NVIM_HOME ]
then
  echo "🧹 unlinking ${GREEN}~/.config/nvim"
  rm $NVIM_HOME

  if [ -d ${NVIM_HOME}.backup ]
  then
    echo "📦 Restoring backup"
    mv $NVIM_HOME.backup $NVIM_HOME
  fi
else
  echo "✅ ${GREEN}~/.config/nvim${NC} is not symlinked"
fi

# Remove NvChad
if [ -d "$NVCHAD" ]
then
  echo "🧹 deleting ${GREEN}${NVCHAD}"
  rm -rf $NVCHAD
else
  echo "✅ ${GREEN}${NVCHAD} is not present"
fi

# Remove ZSH configs
if [ -L $HOME/.zsh.prompts ]
then
  echo "🧹 unlinking ${GREEN}~/.zsh.prompts"
  rm $HOME/.zsh.prompts
else
  echo "✅ ${GREEN}~/.zsh.prompts${NC} is not symlinked"
fi
if [ -L $HOME/.zsh.after ]
then
  echo "🧹 unlinking ${GREEN}~/.zsh.after"
  rm $HOME/.zsh.after
else
  echo "✅ ${GREEN}~/.zsh.after${NC} is not symlinked"
fi

# Remove Prezto configs
echo "Removing Prezto Configs"
  for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
    if [ -L "${HOME}/.${rcfile:t}" ]
    then
      echo "🧹 unlinking ${GREEN}${HOME}/.${rcfile:t}${NC}"
      rm "${HOME}/.${rcfile:t}"
    else 
      echo "✅ ${GREEN}.${rcfile:t}${NC} is not symlinked"
    fi
  done
