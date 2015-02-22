# OSX-only stuff. Abort if not OSX.
is_osx || return 1

# Install system python packages
packages=(
  virtualenvwrapper
)

# This removes the version numbers from the `pip list` command output so it can be used as input for install.
function remove_versions() {
  local list out
  list=($1)
  out=(${list[@]//(*})
  echo "${out[@]}"
}
current=$(remove_versions "$(syspip list)")
list="$(to_install "${packages[*]}" "${current[*]}")"
for pkg in $list; do
  syspip install $pkg
done
