# Editing

if [[ ! "$SSH_TTY" ]] && is_osx; then
  export EDITOR='atom'
  export LESSEDIT='micro'
  export GIT_EDITOR='micro'
else
  export EDITOR='vim'
fi

export VISUAL="$EDITOR"

# Open shortcut
alias o="open"
alias o.="open ."

function q() {
  if [[ -t 0 ]]; then
    $EDITOR "$@"
  else
    # Read from STDIN (and hide the annoying "Reading from stdin..." message)
    $EDITOR - > /dev/null
  fi
}
alias qs="q $DOTFILES"
alias q.='q .'
