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
export PIP_REQUIRE_VIRTUALENV=false
if [[ -r /usr/local/bin/virtualenvwrapper.sh ]]; then
  source /usr/local/bin/virtualenvwrapper.sh
else
  echo "WARNING: Can't find virtualenvwrapper.sh"
fi

# Quick virtual environments
venv(){
  local re='^(2|3)$'
  local envname=$1
  local version=`which python3`
  if [[ $1 =~ $re ]] ; then
    envname=$2
    version=`which python$1`
  fi

  if [[ ! $envname ]]; then
    echo "Defaulting to current directory for environment name"
    envname=$(basename $PWD);
  fi

  # Create
  mkvirtualenv -p "$version" "$envname"

  # Setup for direnv
  echo "workon $envname" >> .envrc

  # Ignore some stuff
  git ignore .env

  # Activate it now
  workon "$envname"
}
