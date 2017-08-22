# Load nave- and npm-related functions.
source $DOTFILES/source/50_node.sh init

# Global npm modules to install.
npm_globals=(
  @abcnews/aunty
  babel-cli
  bower
  eslint
  forever
  grunt-cli
  grunt-init
  hexo-cli
  karma-cli
  @captainsafia/legit
  licensor
  linken
  mocha
  tldr
  trash
  uglify-js
  yo
  generator-data-analysis
)

# Install latest  Node.js, set as default, install global npm modules.
nave_install stable
