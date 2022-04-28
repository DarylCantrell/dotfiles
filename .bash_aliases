### Basic unix commands

alias j='jobs'

# Temporary to break my "ls" muscle memory
# Also note: if '*' annotations become too common, bring back "--file-type"
# alias ls='ls -GAhvF --color=auto --group-directories-first --file-type'
# alias l='ls'
# alias ll='ls -l'

alias dir='echo \! && false'
alias ls='echo \! && false'

alias l='/bin/ls -GAhvF --color=auto --group-directories-first'
alias ll='/bin/ls -l -GAhvF --color=auto --group-directories-first'

alias path='realpath -e'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias up='cd ..'
alias up1='cd ..'
alias up2='cd ../..'
alias up3='cd ../../..'
alias up4='cd ../../../..'
alias up5='cd ../../../../..'
alias up6='cd ../../../../../..'

alias d='dirs'
alias pd='pushd'
alias pp='popd'

### Add an "alert" alias for long running commands.  Use like so: sleep 10; alert

alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

### Git commands

alias stat='git status'

alias unstage='git restore --staged'

alias diff='git diff -w'
alias diff0='git diff -w -U0'
alias show='git show -w'
alias show0='git show -w -U0'

alias sns='git show --pretty="%C(yellow)commit %H%n%C(white)tree %t%n%C(brightred)parents %p" --name-status'
alias dns='git diff --name-status'

alias 1ln='git log --oneline --first-parent'
alias logid='git log --pretty="%C(yellow)%h %C(green)%<(12,trunc)%al %C(white)tree %t %C(brightred)parents %<(26,trunc)%p %C(white)%<(62,trunc)%s"'

alias log='echo "██   ██   ██   ██   ██   ██   ██   ██   ██   ██   ██   ██   ██   ██   ██   ██"; git log --decorate --format=full'
alias log1='log -1'
alias log2='log -2'
alias log3='log -3'
alias log5='log -5'
alias log9='log -9'

alias logsig='log --show-signature'

title() {
  local title="$*"
  if [ -z "$title" ]; then
    title=" "
  fi

  echo -e -n "\e]0;${title}\a"
}

### github/github

if [ -f /workspaces/github/README.md ]; then
  alias monasign='git commit --gpg-sign=27A08E3AFB8CDD4C0D4FE226AD3B4A12FAD9D319'

  alias sqlrepos='mysql -D github_development_repositories'

  alias gitauth='overmind c gitauth'

  server() {
    title "gh-server"
    /workspaces/github/bin/server -d || true
    title
  }

  server_debug() {
    title "gh-server-debug"
    BYEBUGDAP=1 /workspaces/github/bin/server -d || true
    title
  }

  gitauth_debug() {
    title "gitauthd-debug"
    overmind stop gitauth && BYEBUGDAP=1 /workspaces/github/script/gitauth-server --debug || true
    title
  }

  newbranch() {
    if [ -z "$@" ]; then
      echo "Usage: newbranch <branch...>"
      return 1
    fi

    for branch in $*; do
      local filename=${branch//\//_}

      git checkout main || return 1
      git checkout -b $branch || return 1

      echo $branch >> $filename
      git add $filename

      git commit -m "New $branch"
    done

    git checkout main
  }

  pushnewbranch() {
    newbranch $*

    git push --set-upstream origin $*
  }

  touchbranch() {
    if [ -z "$@" ]; then
      echo "Usage: touchbranch <branch...>"
      return 1
    fi

    for branch in $*; do
      local filename=${branch//\//_}

      git checkout $branch || return 1

      echo $branch >> $filename
      git add $filename

      git commit -m "Update $branch"
    done

    git checkout main
  }

  pushtouchbranch() {
    touchbranch $*

    git push origin $*
  }
fi

