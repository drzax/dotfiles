# Get or update all the grunt-init templates
clone_or_pull git@bitbucket.org:abcdevelop/news-template-interactive-gruntinit.git ~/.grunt-init/abc-interactive

# ABC Proxyless
clone_or_pull git@bitbucket.org:abcdevelop/news-proxyless-util.git ~/proxyless

# Exit if Atom is not installed.
[[ ! "$(type -P apm)" ]] && e_error "Atom packages need Atom (and apm) to install." && return 1

packages=(
  linter
  merge-conflicts
)

# This removes the version numbers from the output of `apm list --installed --bare`
function remove_versions() {
  local list out
  list=($1)
  out=(${list[@]//@*})
  echo "${out[@]}"
}

# Install Atom packages.
function apm_install_packages() {
  local current
  current=$(remove_versions "$(apm list --installed --bare)")
  packages=($(setdiff "${packages[*]}" "${current[*]}"))
  if (( ${#packages[@]} > 0 )); then
    e_header "Installing Atom modules: ${packages[*]}"
    for package in "${packages[@]}"; do
      apm install $package
    done
  fi
}

apm_install_packages
