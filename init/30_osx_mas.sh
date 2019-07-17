# OSX-only stuff. Abort if not OSX.
is_osx || return 1

# Exit if Homebrew is not installed.
[[ ! "$(type -P mas)" ]] && e_error "The 'mas' cli tool is required to install Mac App Store apps from here." && return 1

# Homebrew recipes
apps=(
1278508951 # Trello (2.10.13)
497799835 # Xcode (10.2.1)
1091189122 # Bear (1.6.15)
557168941 # Tweetbot (2.5.8)
1147396723 # WhatsApp (0.3.3328)
889428659 # xScope (4.3.3)
)

# This removes the version numbers and text description leaving only ids.
function remove_mas_cruft() {
  local list out
  list=(${1}) # Make a list
  out=(${list[@]/"\s.*"}) # remove path prefix
  echo "${out[@]}"
}

# Install Homebrew recipes.
function mas_install_apps() {
  local installed required
  installed=$(remove_mas_cruft "$(mas list)")
  required=($(setdiff "${apps[*]}" "${installed[*]}"))
  if (( ${#required[@]} > 0 )); then
    e_header "Installing Mac App Store apps: ${required[*]}"
    for app in "${required[@]}"; do
      mas install $app
    done
  fi
}

mas_install_apps

# Misc cleanup!

# This is where brew stores its binary symlinks
local binroot="$(brew --config | awk '/HOMEBREW_PREFIX/ {print $2}')"/bin

# htop
if [[ "$(type -P $binroot/htop)" ]] && [[ "$(stat -L -f "%Su:%Sg" "$binroot/htop")" != "root:wheel" || ! "$(($(stat -L -f "%DMp" "$binroot/htop") & 4))" ]]; then
  e_header "Updating htop permissions"
  sudo chown root:wheel "$binroot/htop"
  sudo chmod u+s "$binroot/htop"
fi

# bash
if [[ "$(type -P $binroot/bash)" && "$(cat /etc/shells | grep -q "$binroot/bash")" ]]; then
  e_header "Adding $binroot/bash to the list of acceptable shells"
  echo "$binroot/bash" | sudo tee -a /etc/shells >/dev/null
fi
if [[ "$(dscl . -read ~ UserShell | awk '{print $2}')" != "$binroot/bash" ]]; then
  e_header "Making $binroot/bash your default shell"
  sudo chsh -s "$binroot/bash" "$USER" >/dev/null 2>&1
  e_arrow "Please exit and restart all your shells."
fi
