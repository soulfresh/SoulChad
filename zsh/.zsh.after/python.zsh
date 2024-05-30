# Pip3 requires using an environment in order to install libraries/binaries.
# This file will create or source a default environment Python environment.
# It requires Python 3 and Pip 3.

# Create an environment folder
if [[ ! -e ~/.env ]]; then
  mkdir ~/.env
fi

if [[ -e ~/.venv/bin/activate ]]; then
  # Source our personal python environment
  source ~/.venv/bin/activate
elif [[ ! -e ~/.env ]]; then
  # Create a Python virtual environment where we can install personal python
  # libraries.
  python3 -m venv ~/.venv
fi
