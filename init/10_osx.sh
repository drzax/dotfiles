# OSX-only stuff. Abort if not OSX.
[[ "$OSTYPE" =~ ^darwin ]] || return 1

# Some tools look for XCode, even though they don't need it.
# https://github.com/joyent/node/issues/3681
# https://github.com/mxcl/homebrew/issues/10245
if [[ ! -d "$('xcode-select' -print-path 2>/dev/null)" ]]; then
  sudo xcode-select -switch /usr/bin
fi

# Install Homebrew.
if [[ ! "$(type -P brew)" ]]; then
  e_header "Installing Homebrew"
  true | ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
fi

if [[ "$(type -P brew)" ]]; then
  # Tap some kegs
  taps=(
    phinze/cask
    homebrew/science
    caskroom/fonts
  )

  list="$(to_install "${taps[*]}" "$(brew tap)")"
  if [[ "$list" ]]; then
    e_header "Tapping Homebrew kegs: $list"
    for tap in $list; do
      brew tap $tap
    done
  fi

  e_header "Updating Homebrew"
  brew doctor
  brew update

  # Install Homebrew recipes.
  recipes=(
    bash
    ssh-copy-id
    git git-extras hub gist
    tree sl id3tool cowsay
    lesspipe nmap
    htop-osx man2html
    wget
    curl-ca-bundle
    todo-txt
    python
    brew-cask
  )

  list="$(to_install "${recipes[*]}" "$(brew list)")"
  if [[ "$list" ]]; then
    e_header "Installing Homebrew recipes: $list"
    brew install $list
  fi

  # This is where brew stores its binary symlinks
  local binroot="$(brew --config | awk '/HOMEBREW_PREFIX/ {print $2}')"/bin

  # htop
  if [[ "$(type -P $binroot/htop)" && "$(stat -L -f "%Su:%Sg" "$binroot/htop")" != "root:wheel" || ! "$(($(stat -L -f "%DMp" "$binroot/htop") & 4))" ]]; then
    e_header "Updating htop permissions"
    sudo chown root:wheel "$binroot/htop"
    sudo chmod u+s "$binroot/htop"
  fi

  # bash
  if [[ "$(type -P $binroot/bash)" && "$(cat /etc/shells | grep -q "$binroot/bash")" ]]; then
    e_header "Adding $binroot/bash to the list of acceptable shells"
    echo "$binroot/bash" | sudo tee -a /etc/shells >/dev/null
  fi
  if [[ "$SHELL" != "$binroot/bash" ]]; then
    e_header "Making $binroot/bash your default shell"
    sudo chsh -s "$binroot/bash" "$USER" >/dev/null 2>&1
    e_arrow "Please exit and restart all your shells."
  fi

  # i don't remember why i needed this?!
  if [[ ! "$(type -P gcc-4.2)" ]]; then
    e_header "Installing Homebrew dupe recipe: apple-gcc42"
    brew install https://raw.github.com/Homebrew/homebrew-dupes/master/apple-gcc42.rb
  fi

  # Install Homebrew Casks.
  casks=(
    qlcolorcode qlstephen qlmarkdown quicklook-json qlprettypatch 
    quicklook-csv betterzipql webp-quicklook suspicious-package
    font-anonymous-pro
  )

  list="$(to_install "${casks[*]}" "$(brew cask list)")"
  if [[ "$list" ]]; then
    e_header "Installing Homebrew Cask recipes: $list"
    brew cask install $list
  fi

fi

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

# Package control for Sublime Text
SUBL_PACKAGES=~/Library/Application\ Support/Sublime\ Text\ 3/Installed\ Packages
if [[ ! -f $SUBL_PACKAGES/Package\ Control.sublime-package ]]; then
   e_header "Installing Package Controller for Sublime Text";
   mkdir -p $SUBL_PACKAGES
   curl https://sublime.wbond.net/Package%20Control.sublime-package -o "$SUBL_PACKAGES/Package Control.sublime-package"
fi