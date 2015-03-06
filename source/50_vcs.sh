
# Git shortcuts

alias g='git'
function ga() { git add "${@:-.}"; } # Add all files by default
alias gp='pushToOrigin'
alias gpa='gp --all'
alias gu='git pull'
alias gl='git log'
alias gfe='git fetch'
alias gfep='git fetch -p'
alias gg='gl --decorate --oneline --graph --date-order --all'
alias gs='git status'
alias gst='gs'
alias gd='git diff'
alias gdc='gd --cached'
alias gm='git commit -m'
alias gma='git commit -am'
alias gb='git branch'
alias gba='git branch -a'
function gc() { git checkout "${@:-master}"; } # Checkout master by default
alias gco='gc'
alias gcb='gc -b'
alias gbc='gc -b' # Dyslexia
alias gr='git remote'
alias grv='gr -v'
#alias gra='git remote add'
alias grr='git remote rm'
alias gcl='git clone'
alias gcd='git rev-parse 2>/dev/null && cd "./$(git rev-parse --show-cdup)"'

# set user quickly
alias gcu='git config user.email simon@elvery.net'
alias gcuabc='git config user.email elvery.simon@abc.net.au'

pushToOrigin(){
  BRANCH=`git rev-parse --symbolic-full-name --abbrev-ref HEAD`;
  echo "git push origin $BRANCH";
  git push origin $BRANCH;
}

# Current branch or SHA if detached.
alias gbs='git branch | perl -ne '"'"'/^\* (?:\(detached from (.*)\)|(.*))/ && print "$1$2"'"'"''

# Run commands in each subdirectory.
alias gu-all='eachdir git pull'
alias gp-all='eachdir git push'
alias gs-all='eachdir git status'

# open all changed files (that still actually exist) in the editor
function ged() {
  local files=()
  for f in $(git diff --name-only "$@"); do
    [[ -e "$f" ]] && files=("${files[@]}" "$f")
  done
  local n=${#files[@]}
  echo "Opening $n $([[ "$@" ]] || echo "modified ")file$([[ $n != 1 ]] && \
    echo s)${@:+ modified in }$@"
  q "${files[@]}"
}

# add a github remote by github username
function gra() {
  if (( "${#@}" != 1 )); then
    echo "Usage: gra githubuser"
    return 1;
  fi
  local repo=$(gr show -n origin | perl -ne '/Fetch URL: .*github\.com[:\/].*\/(.*)/ && print $1')
  gr add "$1" "git://github.com/$1/$repo"
}

# GitHub URL for current repo.
function gurl() {
  local remotename="${@:-origin}"
  local remote="$(git remote -v | awk '/^'"$remotename"'.*\(push\)$/ {print $2}')"
  [[ "$remote" ]] || return
  local user_repo="$(echo "$remote" | perl -pe 's/.*://;s/\.git$//')"
  echo "https://github.com/$user_repo"
}
# GitHub URL for current repo, including current branch + path.
alias gurlp='echo $(gurl)/tree/$(gbs)/$(git rev-parse --show-prefix)'

# git log with per-commit cmd-clickable GitHub URLs (iTerm)
function gf() {
  git log $* --name-status --color | awk "$(cat <<AWK
    /^.*commit [0-9a-f]{40}/ {sha=substr(\$2,1,7)}
    /^[MA]\t/ {printf "%s\t$(gurl)/blob/%s/%s\n", \$1, sha, \$2; next}
    /.*/ {print \$0}
AWK
  )" | less -F
}

# open last commit in GitHub, in the browser.
function gfu() {
  local n="${@:-1}"
  n=$((n-1))
  git web--browse  $(git log -n 1 --skip=$n --pretty=oneline | awk "{printf \"$(gurl)/commit/%s\", substr(\$1,1,7)}")
}
# open current branch + path in GitHub, in the browser.
alias gpu='git web--browse $(gurlp)'

# Just the last few commits, please!
for n in {1..5}; do alias gf$n="gf -n $n"; done

function gj() { git-jump "${@:-next}"; }
alias gj-='gj prev'

# OSX-specific Git shortcuts
if is_osx; then
  alias gdk='git ksdiff'
  alias gdkc='gdk --cached'
  function gt() {
    local path repo
    {
      pushd "${1:-$PWD}"
      path="$PWD"
      repo="$(git rev-parse --show-toplevel)"
      popd
    } >/dev/null 2>&1
    if [[ -e "$repo" ]]; then
      echo "Opening git repo $repo."
      gittower "$repo"
    else
      echo "Error: $path is not a git repo."
    fi
  }
fi

# Open source tree
function st() {
  if [[ ! $1 ]]; then
    if [ -d .git ]; then
      open -a SourceTree .
    else
      open -a SourceTree
    fi
  else
    open -a SourceTree $1
  fi
}

# Open this repository / branch on a hosted remote (default to origin)
function or() {

  local repo branch host user branch_path remote get_remote

  if (( "${#@}" > 1 )); then
    echo -e "Usage: hosted [remote]\n\tremote defaults to 'origin'"
    return 1
  fi

  remote=$1
  [[ $remote ]] || remote='origin'

  get_remote="$(gr show -n $remote 2>/dev/null)"

  repo=$(echo $get_remote | perl -ne '/Fetch URL: .*(bitbucket\.org|github\.com|stash.abc-dev.net.au)[:\/0-9]+.*\/(.*)\.git/ && print $2')
  host=$(echo $get_remote | perl -ne '/Fetch URL: .*(bitbucket\.org|github\.com|stash.abc-dev.net.au)[:\/0-9]+.*\/(.*)\.git/ && print $1')
  branch="$(git branch | perl -ne '/^\* (.*)/ && print $1')"
  user=$(echo $get_remote | perl -ne '/Fetch URL: .*(bitbucket\.org|github\.com|stash.abc-dev.net.au)[:\/0-9]+(.*)\/(.*)\.git/ && print $2')

  if [[ ! $repo ]]; then
    echo "Git remote '$remote' not found. Available remotes: "
    gr
    return 1
  fi

  branch_path="tree/"
  if [[ $host == 'bitbucket.org' ]]; then
    branch_path='branch/'
  fi

  if [[ $host == 'stash.abc-dev.net.au' ]]; then
    user="projects/$user/repos"
    branch_path='browse?at=refs%2Fheads%2F'
    # open "https://$host/projects/$user/repos/$repo/browse?at=refs%2Fheads%2F$branch"
  fi

  if [[ $branch == 'master' ]]; then
    open "https://$host/$user/$repo"
  else
    open "https://$host/$user/$repo/$branch_path$branch"
  fi
}
