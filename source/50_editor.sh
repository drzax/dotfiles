# Editing

if [[ ! "$SSH_TTY" ]] && is_osx; then
  export EDITOR='atom'
  export LESSEDIT='mvim ?lm+%lm -- %f'
else
  export EDITOR='vim'
fi

export VISUAL="$EDITOR"

# Open shortcut
alias o="open"
alias o.="open ."

alias q="$EDITOR"
alias qs="q $DOTFILES"
alias q.='q .'
