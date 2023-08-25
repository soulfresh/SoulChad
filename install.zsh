#!/bin/sh

# TODO Also setup:
# - ZSH
# - Set ZSH as default shell
# - Setup Pretzo: https://github.com/sorin-ionescu/prezto
# - get nerd font (getNf)

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

NVIM_HOME="$HOME/.config/nvim"
# TODO find an alternative tot he realpath command so we don't have to
# brew install coreutils before we can use this script.
ROOT=$(realpath ../)
DOTFILES=$(pwd)
CONFIG=$(realpath ./nvchad)

hadError=false

# TODO Exit if no brew

echo "Install/Upgrade required commandline dependencies?"
select yn in "Yes" "No"; do
  case $yn in
    Yes ) installBrew = true; break;;
    No ) break;;
  esac
done

# TODO Do the following conditionally
# Pre-reqs
# brew install coreutils # realpath
# brew install ripgrep # grep searching with Telescope.

if [ "$installBrew" = true ]; then
  echo "🚗 Installing/Upgrading commandline tools..."

  # Install brew if it doesn't exist
  if [[ $(command -v brew) == "" ]]; then
    echo "👷 Installing Hombrew"
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  else
    echo "🌱 Updating Homebrew"
    brew update
  fi

  # Use the bundle file to install system dependencies
  brew bundle install --file "${DOTFILES}/Brewfile"
  echo "✅ ${GREEN} Installed/Upgraded commandline tools"
fi 

# Symlink Prezto prompt
# if the file doesn't exists and is not a directory
if [ ! -d "${HOME}/.zsh.prompts/prompt_mwren_setup" ]
then
  echo "🔗 Linking ZSH Prompt $DOTFILES"
  cp $DOTFILES/zsh/prezto/prompt_mwren_setup $HOME/.zsh.prompts/prompt_mwren_setup
else
  # If the file is already there, replace it
  if [ -L "${HOME}/.zsh.prompts/prompt_mwren_setup" ]
  then
    cp $DOTFILES/zsh/prezto/prompt_mwren_setup $HOME/.zsh.prompts/prompt_mwren_setup
    echo "✅ ${GREEN}Prompts${NC} linked"
  else
    echo "🙈 ${RED}${HOME}/.zsh.prompts/prompt_mwren_setup${NC} already exists and is not a symlink. You will need to backup your custom config before proceeding."
    hadError=true
  fi
fi

# Install Nerd Fonts
if [ ! -d "../GetNerdFonts" ]
then
  echo "🚗 cloning NerdFonts"
  git clone https://github.com/ronniedroid/getnf.git $ROOT/GetNerdFonts
  echo "✅ ${GREEN}GetNerdFonts${NC} ready"
else
  echo "✅ ${GREEN}GetNerdFonts${NC} already checked out"
fi

# Copy chadrc.lua.template to chadrc.lua (if it doesn't already exist)
if [ ! -e "nvchad/chadrc.lua" ]
then
  cp ./nvchad/chadrc.lua.template ./nvchad/chadrc.lua
fi

# Clone NvChad along side this folder
if [ ! -d "../NvChad" ]
then
  echo "🚗 cloning NvChad"
  git clone https://github.com/NvChad/NvChad $ROOT/NvChad --depth 1
  echo "✅ ${GREEN}NvChad${NC} ready"
else
  echo "✅ ${GREEN}NvChad${NC} already checked out"
fi

# Symlink nvchad-config into NvChad/lua/custom
if [ ! -d "../NvChad/lua/custom" ]
then
  echo "🔗 Linking nvchad-config"
  ln -s $CONFIG $ROOT/NVChad/lua/custom
else
  if [ -L "../NvChad/lua/custom" ]
  then
    echo "✅ ${GREEN}NvChad/lua/custom${NC} already linked"
  else
    echo "🙈 ${RED}../NvChad/lua/custom${NC} already exists and is not a symlink. You will need to backup your custom config before proceeding."
    hadError=true
  fi
fi

# Symlink NvChad into ~/.config/nvim
if [ -e "$NVIM_HOME" ]
then
  if [ -L "$NVIM_HOME" ]
  then
    if [ -d "$NVIM_HOME" ]
    then
      echo "✅ ${GREEN}$NVIM_HOME${NC} is already linked to ${GREEN}$(cd -P "$NVIM_HOME" && pwd)"
    else
      echo "✅ ${GREEN}$NVIM_HOME${NC} is already linked to ${GREEN}$(realpath "$NVIM_HOME")"
    fi
  else
    echo "📦 Backing up existing nvim config to ${GREEN}.config/nvim.backup"
    mv $NVIM_HOME $NVIM_HOME.backup
    echo "🔗 Linking NvChad into ${GREEN}~/.config/nvim"
    ln -s $ROOT/NvChad ~/.config/nvim
  fi
else
  echo "🔗 Linking NvChad into ${GREEN}~/.config/nvim"
  ln -s $ROOT/NvChad ~/.config/nvim
fi

if [ hadError = true ]
then
  echo "${RED} There was an error during install.${NC}"
else
  echo "${GREEN} Install successful!${NC}"
  echo "You can now install any Nerd Fonts you want with the 'getnf' commandline tool"
fi
