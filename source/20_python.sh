# Provide access to sys pip
# See: http://hackercodex.com/guide/python-development-environment-on-mac-osx/
syspip(){
  PIP_REQUIRE_VIRTUALENV="" pip "$@"
}

# Enable pyenv shims and autocompletion
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi

# Quick virtual environments
venv(){
  # Create
  virtualenv .venv

  # Setup for autoenv
  echo "source .venv/bin/activate" >> .env

  # Ignore some stuff
  git ignore .env
  git ignore .venv

  # Activate it now
  source .venv/bin/activate
}

# Quick Anaconda environment
cenv() {

  # TODO: This currently assumes the environment is already created.

  if [[ ! $1 ]]; then
    echo "Specify a conda environment"
    conda env list
    return 1
  fi

  # Setup for autoenv
  echo "source activate $1" >> .env
  source activate "$1"
  git ignore .env

  # Export the environment
  conda env export > environment.yml
}