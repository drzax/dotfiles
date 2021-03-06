[[ "$1" != init && ! -e ~/.nave ]] && return 1

export PATH
PATH=~/.nave/installed/default/bin:"$(path_remove ~/.nave/installed/*/bin)"

# Set a specific version of node as the "default" for "nave use default"
function nave_default() {
  local version
  local default=${NAVE_DIR:-$HOME/.nave}/installed/default
  [[ ! "$1" ]] && echo "Specify a node version or \"stable\"" && return 1
  [[ "$1" == "stable" ]] && version=$(nave stable) || version=${1#v}
  rm "$default" 2>/dev/null
  ln -s $version "$default"
  echo "Nave default set to $version"
}

# Install a version of node, set as default, install npm modules, etc.
function nave_install() {
  local version
  [[ ! "$1" ]] && echo "Specify a node version or \"stable\"" && return 1
  [[ "$1" == "stable" ]] && version=$(nave stable) || version=${1#v}
  if [[ ! -d "${NAVE_DIR:-$HOME/.nave}/installed/$version" ]]; then
    e_header "Installing Node.js $version"
    nave install $version
  fi
  [[ "$1" == "stable" ]] && nave_default stable && npm_install
}

# Use the version of node in the local .nvmrc file
alias nvmrc='exec nave use $(<.nvmrc)'

# Global npm modules to install.
npm_globals=(
  @abcnews/aunty
  @captainsafia/legit
  babel-cli
  bower
  eslint
  generator-data-analysis
  grunt-cli
  grunt-init
  hexo-cli
  licensor
  linken
  serve
  serverless
  tldr
  trash
  uuid
  yo
)

# Because "rm -rf node_modules && npm install" takes WAY too long. Not sure
# if this really works as well, though. We'll see.
alias npm_up='npm prune && npm install && npm update'

# Run arbitrary command with npm "bin" directory in PATH.
function npm_run() {
  git rev-parse 2>/dev/null && (
    PATH="$(git rev-parse --show-toplevel)/node_modules/.bin:$PATH"
    "$@"
  )
}

# This removes the version numbers and tree prefix from the `npm list -g --depth=0 --parseable` command output so it can be used as input for install.
function remove_npm_cruft() {
  local list out
  list=(${1}) # Make a list
  list=("${list[@]:1}") # Remove fist item
  out=(${list[@]/"$(npm config get prefix)/lib/node_modules/"}) # remove path prefix
  echo "${out[@]}"
}

# Update npm and install global modules.
function npm_install() {
  local installed modules
  e_header "Updating npm"
  npm update -g npm
  installed=$(remove_npm_cruft "$(npm list -g --depth=0 --parseable)")
  modules=($(setdiff "${npm_globals[*]}" "${installed[*]}"))
  if (( ${#modules[@]} > 0 )); then
    e_header "Installing Npm modules: ${modules[*]}"
    npm install -g "${modules[@]}"
  fi
}

# Publish module to Npm registry, but don't update "latest" unless the version
# is an actual release version!
function npm_publish() {
  local version="$(node -pe 'require("./package.json").version' 2>/dev/null)"
  if [[ "${version#v}" =~ [a-z] ]]; then
    local branch="$(git branch | perl -ne '/^\* (.*)/ && print $1')"
    echo "Publishing dev version $version with --force --tag=$branch"
    npm publish --force --tag="$branch" "$@"
  else
    echo "Publishing new latest version $version"
    npm publish "$@"
  fi
}

# Crazy-ass, cross-repo npm linking.

# Inter-link all projects, where each project exists in a subdirectory of
# the current parent directory. Uses https://github.com/cowboy/node-linken
alias npm_linkall='eachdir "rm -rf node_modules; npm install"; linken */ --src .'
alias npm_link='rm -rf node_modules; npm install; linken . --src ..'

# Look at a project's package.json and figure out what dependencies can be
# updated. While the "npm outdated" command only lists versions that are valid
# per the version string in package.json, this looks at the @latest tag in npm.
function npm_latest() {
  if [[ -e 'node_modules' ]]; then
    echo 'Backing up node_modules directory.'
    mv "node_modules" "node_modules-$(date "+%Y_%m_%d-%H_%M_%S")"
  fi
  local deps='JSON.parse(require("fs").readFileSync("package.json")).dependencies'
  # Install the latest version of all dependencies listed in package.json.
  echo 'Installing @latest version of all dependencies...'
  npm install $(node -pe "Object.keys($deps).map(function(m){return m+'@latest'}).join(' ')");
  # List all dependencies that are now invalid, along with their (new) version.
  local npm_ls="$(npm ls 2>/dev/null)"
  if echo "$npm_ls" | grep invalid >/dev/null; then
    echo -e '\nTHESE DEPENDENCIES CAN POSSIBLY BE UPDATED\n'
    echo 'Module name:                   @latest:             package.json:'
    echo "$npm_ls" | perl -ne "m/.{10}(.+)@(.+?) invalid\$/ && printf \"%-30s %-20s %s\", \$1, \$2, \`node -pe '$deps[\"\$1\"]'\`"
    return 99
  else
    echo -e '\nAll dependencies are @latest version.'
  fi
}

# Force npm to rewrite package.json to sort everything in the default order
function npm-package() {
  if [[ "$(cat package.json | grep dependencies)" ]]; then
    npm install foo --save && npm uninstall foo --save
  fi
  if [[ "$(cat package.json | grep devDependencies)" ]]; then
    npm install foo --save-dev && npm uninstall foo --save-dev
  fi
}
