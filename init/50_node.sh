# Load nave- and npm-related functions.
source $DOTFILES/source/50_node.sh

# Global npm modules to install.
npm_globals=(
  bower
  forever
  grunt-cli
  grunt-init
  hexo-cli
  karma-cli
  linken
  mocha
  node-inspector
  tldr
  trash
  uglify-js
  yo
  generator-data-analysis
)

# Install latest  Node.js, set as default, install global npm modules.
nave_install stable