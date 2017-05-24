# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

alias grep='grep --color=auto'

# Prevent less from clearing the screen while still showing colors.
export LESS=-XR

# Set the terminal's title bar.
function titlebar() {
  echo -n $'\e]0;'"$*"$'\a'
}

# SSH auto-completion based on entries in known_hosts.
if [[ -e ~/.ssh/known_hosts ]]; then
  complete -o default -W "$(cat ~/.ssh/known_hosts | sed 's/[, ].*//' | sort | uniq | grep -v -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')" ssh scp sftp
fi

# From: https://gist.github.com/namuol/9122237
function fuck() {
  killall -9 $2;
  if [ $? == 0 ]
  then
    echo
    echo " (╯°□°）╯︵$(echo $2|flip &2>/dev/null)"
    echo
  fi
}

function pngdatauri() {
  echo "data:image/png;base64,$(pngcrush $1 /dev/stdout | base64)" | pbcopy
}

function svgdatauri() {
  echo "data:image/svg+xml;base64,$(svgo -o - -i $1 | base64)" | pbcopy
}

alias prx='~/proxyless/proxyless-command'


# iOS simulator shortcut
alias ios='open -a "iOS Simulator"'

# crush a whole directory
function pngcrushdir() {
  for png in `find $1 -name "*.png"`;
  do
    echo "crushing $png"
    pngcrush -brute "$png" temp.png
    mv -f temp.png $png
  done;
}

# Alias some docker commands
alias dkc=docker-compose
alias dkm=docker-machine
function dkmuse() { eval $(dkm env "${@:-default}"); } # Checkout master by default
