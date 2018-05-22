# Where the magic happens.
export DOTFILES=~/.dotfiles

# Source all files in "source"
function src() {
  local file
  if [[ "$1" ]]; then
    source "$DOTFILES/source/$1.sh"
  else
    for file in $DOTFILES/source/*; do
      source "$file"
    done
  fi
}

# Run dotfiles script, then source.
function dotfiles() {
  $DOTFILES/bin/dotfiles "$@" && src
}

src


# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[ -f /Users/elverys7d/.nave/installed/8.2.1/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.bash ] && . /Users/elverys7d/.nave/installed/8.2.1/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.bash
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[ -f /Users/elverys7d/.nave/installed/8.2.1/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.bash ] && . /Users/elverys7d/.nave/installed/8.2.1/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.bash