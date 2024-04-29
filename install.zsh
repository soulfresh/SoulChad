#! /bin/zsh
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

###
# Create a symlink for a file.
# @param $0 The file to be symlinked
# @param $1 The symlink name (ie. the symlink pointing to $0)
###
symlink_item () {
  # The file to symlink
  local file=$1
  # The symlink name
  local link=$2
  # Whether file is a directory
  local dir=$3
  # echo "linedFile? $file"
  # echo "link? $link"
  # echo "dir? $dir"

  local fullFilepath=$(readlink -f $file)

  # If the input file doesn't exist, then fail
  if [[ ! -e "${fullFilepath}" ]]; then
    echo "🙈 ${RED}${file}${NC} does not exist"
    hadError=true
    return
  # If the target exists but isn't a type we can easily link, then fail
  elif [[ -e $link ]]; then
    # If we expect a directory
    if [[ $dir == true ]]; then
      if [[ ! -L "${link}" ]] && [[ ! -d "${link}" ]]; then
        echo "⛔️ ${RED}${link}${NC} exists but is not a directory or link."
        echo "Please remove or backup it up before proceeding."
        hadError=true
        return
      fi
    # If we expect a file
    else
      if [[ ! -L "${link}" ]] && [[ ! -f "${link}" ]]; then
        echo "⛔️ ${RED}${link}${NC} exists but is not a file or link."
        echo "Please remove or backup it up before proceeding."
        hadError=true
        return
      fi
    fi
  fi

  # If the file exists and is a file, make a backup
  if [[ -f ${link} ]] && [[ ! -L ${link} ]]; then
    echo "📦 Backing up existing ${GREEN}${file}${NC} to ${GREEN}${file}.backup${NC}"
    mv $link $link.backup
    ls -la $link.backup
  fi

  # Add the symlink
  if [[ ! -e "${link}" ]] || [[ -L "${link}" ]] || [[ -f "${link}" ]]; then
    echo "🔗 Linking ${GREEN}${file}${NC} to ${GREEN}${link}${NC}"
    ln -sfn $fullFilepath $link
    ls -la $link
  fi
}

symlink_file () {
  symlink_item $1 $2 false
} 

symlink_dir () {
  symlink_item $1 $2 true
}

###
# Create symlinks for all files matching the given glob
# @param $0 The file to glob to loop over. This must be passed as a quoted
#           string (ex `symlink_files_matching_glob "git/.git*" ~/`)
# @param $1 The directory into which files should be linked.
###
symlink_multiple_files () {
  local link=$1

  for FILE in "${@:2}"; do
    # if the glob failed to return any files, skip
    if [ ! -e "$FILE" ]
    then
      echo "${RED}No files match ${glob}${NC}"
      continue
    fi

    echo "Linking $FILE"
    symlink_file $FILE "$link/$(basename $FILE)"
  done
}

#########
### START
#########

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

    # echo "Adding Brew to PATH..."
    # (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> $HOME/.zprofile
    # eval "$(/opt/homebrew/bin/brew shellenv)"
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
  echo "✅ ${GREEN}Installed/Upgraded commandline tools${NC}"
fi 

## ZSH
# zsh is now the default shell on OSX
# if [ "$fullInstall" = true ]; then
#   # Make ZSH the default shell
#   echo "🐚 Setting ZSH as default shell"
#   sudo chsh -s $(which zsh) $USER
# fi

## Prezto
if [ ! -d "${ROOT}/prezto" ]
then
  echo "🧬 Cloning Prezto"
  git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ROOT}/prezto"
else
  if [ "$fullInstall" = true ]; then
    echo "♻️  Updating Prezto"
    cd "${ROOT}/prezto"
    git pull
    git submodule sync --recursive
    git submodule update --init --recursive
    cd "${DOTFILES}"
  fi
fi

# Prompt
symlink_dir $ROOT/prezto $HOME/.zprezto
symlink_dir zsh/.zsh.prompts $HOME/.zsh.prompts

# Symlink all files in the prezto/runcoms folder into the home directory
setopt EXTENDED_GLOB
for rcfile in "${ROOT}"/prezto/runcoms/^README.md(.N); do
  ln -sfn "$rcfile" "${HOME}/.${rcfile:t}"
done

# Override some of the default prezto runcoms with my own
symlink_file zsh/prezto-override/.zpreztorc $HOME/.zpreztorc
symlink_file zsh/prezto-override/.zshrc $HOME/.zshrc

# Symlink ZSH Configs
symlink_dir zsh/.zsh.after $HOME/.zsh.after
symlink_dir zsh $HOME/.zsh

# Install NVM
if [ "$fullInstall" = true ]; then
  if [ ! -e "$HOME/.nvm" ]
  then
    echo "🚗 Installing NVM"
    PROFILE=/dev/null bash -c 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash'
  else
    echo "✅ ${GREEN}NVM${NC} already installed"
  fi

  echo "🚗 Upgrading NVM"
  (
    cd "$NVM_DIR"
    git fetch --tags origin
    git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
  ) && \. "$NVM_DIR/nvm.sh"

  if ! command -v node &> /dev/null
  then
    echo "🚗 Installing lastest stable Node"
    nvm use stable
  else
    echo "Current Node version:"
    node --version
  fi
fi


# Symlink Git Configs
symlink_multiple_files $HOME git/.git*

# Install Nerd Fonts
if [ ! -d "../GetNerdFonts" ]
then
  echo "🚗 cloning NerdFonts"
  git clone https://github.com/ronniedroid/getnf.git $ROOT/GetNerdFonts
  cd $ROOT/GetNerdFonts
  ./install.sh
  cd $DOTFILES
  echo "✅ ${GREEN}GetNerdFonts${NC} ready"
else
  # TODO Update
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
  # TODO Update
  echo "✅ ${GREEN}NvChad${NC} already checked out"
fi

# Symlink nvchad-config into NvChad/lua/custom
symlink_dir $CONFIG $ROOT/NVChad/lua/custom

# Symlink tresitter overrides into NVChad/after
symlink_dir $CONFIG/after $ROOT/NVChad/after

# Symlink NvChad into ~/.config/nvim
symlink_dir $ROOT/NvChad $HOME/.config/nvim

# Copy other configs into place
symlink_dir "$DOTFILES/config/neovide" $HOME/.config
# cp -r $DOTFILES/config/neovide $HOME/.config
echo "✅ Copied configs into place"

if [ hadError = true ]
then
  echo "${RED} There was an error during install.${NC}"
else
  echo "🙌 ${GREEN}Install successful!${NC}"
  echo "You can now install any Nerd Fonts you want with the 'getnf' commandline tool"
fi

if [ "$fullInstall" = true ]; then
  echo "🍏 Changing OSX settings"
  ./misc/osx-settings
fi

