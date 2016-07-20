# Provide access to sys pip
# See: http://hackercodex.com/guide/python-development-environment-on-mac-osx/
syspip(){
  PIP_REQUIRE_VIRTUALENV="" pip "$@"
}

# Enable pyenv shims and autocompletion
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi

# Python & virtualenvwrapper
export WORKON_HOME=~/.virtualenvs
if [[ ! -d $WORKON_HOME ]]; then
  mkdir $WORKON_HOME
fi
export PIP_VIRTUALENV_BASE=$WORKON_HOME
export PIP_RESPECT_VIRTUALENV=true
export PIP_REQUIRE_VIRTUALENV=true
if [[ -r /usr/local/bin/virtualenvwrapper.sh ]]; then
  source /usr/local/bin/virtualenvwrapper.sh
else
  echo "WARNING: Can't find virtualenvwrapper.sh"
fi

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
# Inspired by some things:
# - https://github.com/tdhopper/dotfiles/blob/f319aca85d034488d2a37f43e2ee7c49c057cef6/bash_functions#L119-L139
# - http://stiglerdiet.com/blog/2015/Nov/24/my-python-environment-workflow-with-conda/
function cenv {

  local envname=$1

  if [[ ! $envname ]]; then
    echo "Defaulting to current directory for environment name"
    envname=$(basename $PWD);
  fi

  # Setup for autoenv
  echo "source activate $envname" >> .env
  source activate "$envname"
  if git status &> /dev/null; then git ignore .env; fi

  # Export the environment
  conda env export > environment.yml
}