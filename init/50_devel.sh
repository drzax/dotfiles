# Get or update all the grunt-init templates
clone_or_pull ssh://git@ssh.stash.abc-dev.net.au:7999/news/template-interactive-gruntinit.git ~/.grunt-init/abc-interactive

# ABC Proxyless
clone_or_pull ssh://git@ssh.stash.abc-dev.net.au:7999/news/news-proxyless-util.git ~/proxyless

# The hydrogen package for Atom needs python 2.7 to build.
apm config set python $(which python2.7)

# Exit if Atom is not installed.
[[ ! "$(type -P apm)" ]] && e_error "Atom packages need Atom (and apm) to install." && return 1

packages=(
  atom-fuzzy-grep
  atom-import-cost
  busy-signal
  color-picker
  editorconfig
  es6-javascript
  fold-comments
  git-blame
  highlight-selected
  hydrogen
  ide-flowtype
  ide-typescript
  language-lua
  language-r
  linter-eslint
  prettier-atom
  prettier-eslint
  pretty-json
  sync-settings
  tablr
  todo-show
  wordcount
)

# This removes the version numbers from the output of `apm list --installed --bare`
function remove_versions() {
  local list out
  list=($1)
  out=(${list[@]//@*})
  echo "${out[@]}" | tr '[:upper:]' '[:lower:]'
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

e_header "Updating Atom modules"
apm upgrade --no-confirm
