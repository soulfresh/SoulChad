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
NVIM_CACHE="$HOME/.local/share/nvim"
NVIM_STATE="$HOME/.local/state/nvim"
DOTFILES=$(pwd)
CONFIG="$DOTFILES/nvim"

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

merge_toml_without_duplicate_sections () {
  local source_file=$1
  local target_file=$2

  mkdir -p "$(dirname "$target_file")"
  touch "$target_file"

  /usr/bin/python3 - "$source_file" "$target_file" <<'PY'
import pathlib
import re
import sys

source_path = pathlib.Path(sys.argv[1]).expanduser()
target_path = pathlib.Path(sys.argv[2]).expanduser()

source_text = source_path.read_text(encoding="utf-8")
target_text = target_path.read_text(encoding="utf-8") if target_path.exists() else ""

section_re = re.compile(r'^\s*(\[\[?[^\]]+\]\]?)\s*(?:#.*)?$')
key_re = re.compile(r'^\s*([A-Za-z0-9_.-]+)\s*=')

def parse_blocks(text: str):
    blocks = []
    current_header = None
    current_lines = []
    for line in text.splitlines(True):
        m = section_re.match(line)
        if m:
            blocks.append((current_header, current_lines))
            current_header = m.group(1)
            current_lines = [line]
        else:
            current_lines.append(line)
    blocks.append((current_header, current_lines))
    return blocks

def existing_headers(text: str):
    headers = set()
    for line in text.splitlines():
        m = section_re.match(line)
        if m:
            headers.add(m.group(1))
    return headers

def top_level_keys(text: str):
    keys = set()
    seen_section = False
    for line in text.splitlines():
        if section_re.match(line):
            seen_section = True
        if seen_section:
            continue
        m = key_re.match(line)
        if m:
            keys.add(m.group(1))
    return keys

headers_in_target = existing_headers(target_text)
top_keys_in_target = top_level_keys(target_text)
blocks = parse_blocks(source_text)
append_parts = []

for header, lines in blocks:
    if not lines:
        continue
    if header is None:
        for line in lines:
            if not line.strip() or line.lstrip().startswith("#"):
                continue
            m = key_re.match(line)
            if m:
                key = m.group(1)
                if key in top_keys_in_target:
                    continue
                top_keys_in_target.add(key)
            if line in target_text:
                continue
            append_parts.append(line)
        continue

    if header in headers_in_target:
        continue
    append_parts.extend(lines)
    headers_in_target.add(header)

if append_parts:
    merged = target_text
    if merged and not merged.endswith("\n"):
        merged += "\n"
    if merged and not merged.endswith("\n\n"):
        merged += "\n"
    merged += "".join(append_parts)
    target_path.write_text(merged, encoding="utf-8")
PY
}

delete_folder () {
  local folder=$1

  if [ -d $folder ]
  then
    echo "🧹 removing ${GREEN}${folder}${NC}"
    rm -rf $folder
  fi
}

#########
### START
#########

# Clear NVIM cache and state
declare -a folders=(
  $NVIM_CACHE
  $NVIM_STATE
)

for i in "${folders[@]}"
do
  delete_folder "$i"
done

# Make sure PATH includes .local/bin during this install script
PATH=$HOME/.local/bin:$PATH


echo "Install/Upgrade required commandline dependencies?"
select yn in "Yes" "No"; do
  case $yn in
    Yes ) fullInstall=true; break;;
    No ) break;;
  esac
done

## XCode Command Line Tools
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
    # (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> $HOME/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
  echo "Brew version:"
  brew --version
fi
echo ""

if [ "$fullInstall" = true ]; then
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
symlink_file zsh/prezto-override/.zprofile $HOME/.zprofile

# Symlink ZSH Configs
symlink_dir zsh/.zsh.after $HOME/.zsh.after
symlink_dir zsh $HOME/.zsh

# Install NVM
if [ "$fullInstall" = true ]; then
  echo "🚗 Installing NVM"
  PROFILE=/dev/null bash -c 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash'
  # Make NVM available immediately so we can install node.
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

  # if [ ! -e "$HOME/.nvm" ]
  # then
  #   echo "🚗 Installing NVM"
  #   PROFILE=/dev/null bash -c 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash'
  # else
  #   echo "✅ ${GREEN}NVM${NC} already installed"
  # fi
  #
  # echo "🚗 Upgrading NVM"
  # (
  #   cd "$NVM_DIR"
  #   git fetch --tags origin
  #   git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
  # ) && \. "$NVM_DIR/nvm.sh"

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
if [ ! -d "../GetNerdFonts" ]; then
  echo "🚗 cloning NerdFonts"
  git clone https://github.com/ronniedroid/getnf.git $ROOT/GetNerdFonts
elif [ "$fullInstall" = true ]; then
  echo "🚗 upgrading NerdFonts"
  cd $ROOT/GetNerdFonts
  git pull
  cd $DOTFILES
  echo "✅ ${GREEN}GetNerdFonts${NC} updated"
fi

if [ "$fullInstall" = true ]; then
  echo "🚗 installing NerdFonts"
  cd $ROOT/GetNerdFonts
  ./install.sh
  # Install the font configured as my default
  getnf -i FiraCode
  cd $DOTFILES
  echo "✅ ${GREEN}GetNerdFonts${NC} ready"
fi

# Copy chadrc.lua.template to chadrc.lua (if it doesn't already exist)
# if [ ! -e "nvchad/chadrc.lua" ]
# then
#   cp ./nvchad/chadrc.lua.template ./nvchad/chadrc.lua
# fi

# Clone NvChad along side this folder
# if [ ! -d "../NvChad" ]
# then
#   echo "🚗 cloning NvChad"
#   git clone -b v2.0 https://github.com/soulfresh/NvChad $ROOT/NvChad --depth 1
#   echo "✅ ${GREEN}NvChad${NC} ready"
# else
#   # TODO Update
#   echo "✅ ${GREEN}NvChad${NC} already checked out"
# fi

# Symlink nvchad-config into NvChad/lua/custom
# symlink_dir $CONFIG $ROOT/NVChad/lua/custom

# Symlink treesitter overrides into NVChad/after
# symlink_dir $CONFIG/after $ROOT/NVChad/after

# Symlink NvChad into ~/.config/nvim
# symlink_dir $ROOT/NvChad $HOME/.config/nvim
symlink_dir $CONFIG $NVIM_HOME

# Copy other configs into place
symlink_dir "$DOTFILES/config/neovide" $HOME/.config
mkdir -p "$HOME/.claude"
mkdir -p "$HOME/.config/claude"
mkdir -p "$HOME/.config/codex"
mkdir -p "$HOME/.codex"
cp -f "$DOTFILES/config/claude/settings.json" "$HOME/.claude/settings.json"
cp -f "$DOTFILES/config/claude/notify.sh" "$HOME/.config/claude/notify.sh"
chmod +x "$HOME/.config/claude/notify.sh"
cp -f "$DOTFILES/config/codex/notify.sh" "$HOME/.config/codex/notify.sh"
chmod +x "$HOME/.config/codex/notify.sh"
merge_toml_without_duplicate_sections "$DOTFILES/config/codex/config.toml" "$HOME/.codex/config.toml"
# cp -r $DOTFILES/config/neovide $HOME/.config
echo "✅ Copied configs into place"

# Install plugins and restore to lock file versions
echo "🚗 Installing/restoring NVim plugins to lock file versions"
nvim --headless "+Lazy! restore" +qa
echo "✅ NVim plugins installed"

# Install LSP servers, formatters, and linters via Mason
echo "🚗 Installing Mason tools"
nvim --headless "+MasonInstallAll" +qa
echo "✅ Mason tools installed"

# Run health check
echo "🩺 Running NVim health check"
nvim --headless "+checkhealth" "+w! /tmp/nvim-healthcheck.txt" +qa
cat /tmp/nvim-healthcheck.txt
rm /tmp/nvim-healthcheck.txt

# TODO Run :checkhealth lazy after install

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
