# Install Prezto ZSH configuration
# https://github.com/sorin-ionescu/preztohttps://github.com/sorin-ionescu/preztohttps://github.com/sorin-ionescu/prezto

# TODO Update `install.zsh` to prompt the user if they want to install this

ROOT=$(realpath ../)

# Clone prezto locally
git clone --recursive https://github.com/sorin-ionescu/prezto.git "$ROOT/prezto"

# Symlink all files in the prezto/runcoms folder into the home directory
setopt EXTENDED_GLOB
for rcfile in "${ROOT}"/prezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${HOME}/.${rcfile:t}"
done
