# OSX-only stuff. Abort if not OSX.
is_osx || return 1

# Load python-related functions.
source $DOTFILES/source/20_python.sh

# This removes the version numbers from the `pip list` command output so it can be used as input for install.
function remove_versions() {
  local list out
  list=($1)
  out=(${list[@]//[0-9-]*/})
  echo "${out[@]:2}"
}

# Install Python packages
function python_install_packages() {
  local current
  current=$(remove_versions "$(syspip list)")
  packages=($(setdiff "${packages[*]}" "${current[*]}"))
  if (( ${#packages[@]} > 0 )); then
    e_header "Installing Python packages: ${packages[*]}"
    for package in "${packages[@]}"; do
      syspip install $package
    done
  fi
}

# Install system python packages
packages=(
  virtualenv
  virtualenvwrapper
)

python_install_packages
