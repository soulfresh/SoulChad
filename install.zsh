#!/bin/sh
set -e

# shopt -s execfail
# fnc() { echo $?, $_, Oops;}
# trap fnc ERR

# TODO Also setup:
# - get nerd font (getNf)

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

ROOT=$(cd ..; pwd)
NVIM_HOME="$HOME/.config/nvim"
DOTFILES=$(pwd)
CONFIG="$DOTFILES/nvchad"

echo "Using the following paths:"
echo "NVIM_HOME: $NVIM_HOME"
echo "ROOT: $ROOT"
echo "DOTFILES: $DOTFILES"
echo "CONFIG: $CONFIG"
echo ""

fullInstall=false
hadError=false

echo "Install/Upgrade required commandline dependencies?"
select yn in "Yes" "No"; do
  case $yn in
    Yes ) fullInstall=true; break;;
    No ) break;;
  esac
done

if [ "$fullInstall" = true ]; then
  echo "Installing XCode Command Line Tools"
  # Install xcode command line tools
  xcode-select --install || echo "Command Line Tools already installed"
fi

# Make sure brew is installed
if ! command -v brew &> /dev/null
then
    echo "Installing Brew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo ""

    echo "Adding Brew to PATH..."
    (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/marcwren/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
  echo "Brew version:"
  brew --version
fi
echo ""

## XCode Command Line Tools
if [ "$fullInstall" = true ]; then
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

## ZSH
# zsh is now the default shell on OSX
# if [ "$fullInstall" = true ]; then
#   # Make ZSH the default shell
#   echo "🐚 Setting ZSH as default shell"
#   sudo chsh -s $(which zsh) $USER
# fi

## Prezto
if [ ! -d "${HOME}/.zprezto" ]
then
  echo "🧬 Cloning Prezto"
  git clone --recursive https://github.com/sorin-ionescu/prezto.git "${HOME}/.zprezto"
else
  if [ "$fullInstall" = true ] then
    echo "♻️  Updating Prezto"
    cd "${HOME}/.zprezto"
    git pull
    git submodule sync --recursive
    git submodule update --init --recursive
    cd -
  fi
fi

# Prompt
# if the file doesn't exists and is not a directory
if [ ! -d "${HOME}/.zsh.prompts" ]
then
  echo "🔗 Linking ZSH Prompt"
  ln -s $DOTFILES/zsh/.zsh.prompts $HOME
  echo "✅ ${GREEN}ZSH Prompts${NC} linked"
else
  # If the file is already there, replace it
  if [ -L "${HOME}/.zsh.prompts" ]
  then
    ln -sfn $DOTFILES/zsh/.zsh.prompts $HOME
    echo "✅ ${GREEN}Prompts${NC} linked"
  else
    echo "🙈 ${RED}${HOME}/.zsh.prompts${NC} already exists and is not a symlink. You will need to backup your custom config before proceeding."
    hadError=true
  fi
fi

# Symlink ZSH Configs
# if the file doesn't exists and is not a directory
if [ ! -d "${HOME}/.zsh.after" ]
then
  echo "🔗 Linking ZSH After Configs"
  ln -s $DOTFILES/zsh/.zsh.after $HOME
  echo "✅ ${GREEN}ZSH Configs${NC} linked"
else
  # If the file is already there, replace it
  if [ -L "${HOME}/.zsh.after" ]
  then
    ln -sfn $DOTFILES/zsh/.zsh.after $HOME
    echo "✅ ${GREEN}ZSH Configs${NC} linked"
  else
    echo "🙈 ${RED}${HOME}/.zsh.after${NC} already exists and is not a symlink. You will need to backup your custom config before proceeding."
    hadError=true
  fi
fi

if [ ! -d "${HOME}/.zshrc"]
then 
  echo "🔗 Linking ZSH RC file"
  ln -s $DOTFILES/zsh/prezto-overrides/zshrc $HOME
  echo "✅ ${GREEN}${HOME}/.zshrc${NC} linked"
else
  # If the file is already there, replace it
  if [ -L "${HOME}/.zshrc" ]
  then
    ln -sfn $DOTFILES/zsh/prezto-overrides/zshrc $HOME
    echo "✅ ${GREEN}${HOME}/.zshrc${NC} linked"
  else
    echo "📦 Backing up existing nvim config to ${GREEN}.config/nvim.backup"
    mv $NVIM_HOME $NVIM_HOME.backup
    ln -sfn $DOTFILES/zsh/prezto-overrides/zshrc $HOME
    echo "✅ ${GREEN}${HOME}/.zshrc${NC} linked"
  fi
fi

# Symlink Git Configs
echo "🔗 Linking Git Configs ${HOME}/${FILE##*/}"
for FILE in ./git/.git*; do
  # if the glob failed to return any files, skip
  if [ ! -e "$FILE" ]
  then
    echo "${RED}No Git configs to link${NC}"
    continue
  fi

  # if the file doesn't exists and is not a directory
  if [ ! -e "${HOME}/${FILE##*/}" ]
  then
    ln -s $DOTFILES/git/${FILE##*/} $HOME
    echo "✅ ${GREEN}${FILE##*/}${NC} linked"
  else
    # If the file is already there, replace it
    if [ -L "${HOME}/${FILE##*/}" ]
    then
      ln -sfn $DOTFILES/git/${FILE##*/} $HOME
      echo "✅ ${GREEN}${FILE##*/}${NC} linked"
    else
      echo "🙈 ${RED}${HOME}/${FILE##*/}${NC} already exists and is not a symlink. You will need to backup your custom config before proceeding."
      hadError=true
    fi
  fi
done


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
  git clone -b v2.0 https://github.com/NvChad/NvChad $ROOT/NvChad --depth 1
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

# Symlink tresitter overrides into NVChad/after
if [ ! -d "../NvChad/after" ]
then
  echo "🔗 Linking nvim after scripts"
  ln -s $CONFIG/after $ROOT/NVChad/after
else
  if [ -L "../NvChad/after" ]
  then
    echo "✅ ${GREEN}NvChad/after${NC} already linked"
  else
    echo "🙈 ${RED}../NvChad/after${NC} already exists and is not a symlink. You will need to backup your custom config before proceeding."
    hadError=true
  fi
fi

# TODO if `config/chardc.lua` doesn't exist, then copy the template into place

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
  if [ ! -d "$HOME/.config" ]
  then
    mkdir $HOME/.config
  fi
  ln -sfn $ROOT/NvChad $HOME/.config/nvim
fi

# Copy other configs into place
# TODO Convert this into a loop over each file/folder in configs/
cp -r $DOTFILES/config/neovide $HOME/.config
echo "✅ Copied configs into place"

# TODO Copy ZSH configs into place

if [ hadError = true ]
then
  echo "${RED} There was an error during install.${NC}"
else
  echo "🙌 ${GREEN}Install successful!${NC}"
  echo "You can now install any Nerd Fonts you want with the 'getnf' commandline tool"
fi

if [ "$fullInstall" = true ]; then
  echo "🍏 Changing OSX settings"
  ./bin/osx
fi

