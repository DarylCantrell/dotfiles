### Basic unix commands

alias j='jobs'

# Temporary to break my "ls" muscle memory
# Also note: if '*' annotations become too common, bring back "--file-type"
# alias ls='ls -GAhvF --color=auto --group-directories-first --file-type'
# alias l='ls'
# alias ll='ls -l'

alias dir='echo \! && false'
alias ls='echo \! && false'

alias l='/bin/ls -GAHvF --color=auto --group-directories-first'
alias ll='/bin/ls -l -GAHvF --color=auto --group-directories-first'

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

alias 1ln='git log -15 --oneline --first-parent'
alias logid='git log --pretty="%C(yellow)%h %C(green)%<(12,trunc)%al %C(white)tree %t %C(brightred)parents %<(26,trunc)%p %C(white)%<(62,trunc)%s"'

# git log -2 --decorate --format='%C(yellow)commit %H%n%p%nAuthor: %aN <%aE>%nCommit: %cN <%cE> %C(red)%cd%n'
# git log -2 --decorate --format='%C(yellow)Commit: %H %C(auto)%d%nParent: %p%nAuthor: %aN <%aE>%nCommtr: %cN <%cE> %C(red)%cd%n%n%s%n'

alias log='echo "██   ██   ██   ██   ██   ██   ██   ██   ██   ██   ██   ██   ██   ██   ██   ██"; git log --decorate --format="%C(yellow)Commit: %H %C(auto)%d%nParent: %p%nCommtr: %cN <%cE> %C(red)%cd%n%n%s%n"'
alias log1='log -1'
alias log2='log -2'
alias log3='log -3'
alias log4='log -4'
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
  alias monasign='git commit --gpg-sign=AD3B4A12FAD9D319'
  alias collabsign='git commit --gpg-sign=367D8DF8A23D2BAC'

  #alias sqlrepos='mysql -D github_development_repositories'
  alias sql=/workspaces/github/bin/dbconsole

  alias gitauth='overmind c gitauth'

  server() {
    title "gh-server"
    /workspaces/github/bin/server -d || true
    title
  }

  newbranch() {
    if [ -z "$@" ]; then
      echo "Usage: newbranch <branch...>"
      return 1
    fi

    for branch in $*; do
      local filename=${branch//\//_}.txt

      git checkout main || return 1
      git checkout -b $branch || return 1

      echo $branch "`date '+ %F  %H:%M:%S'`" >> $filename
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

    local currentBranch = `git branch --show-current`

    for branch in $*; do
      local filename=${branch//\//_}.txt

      git checkout $branch || return 1

      echo $branch "`date '+ %F  %H:%M:%S'`" >> $filename
      git add $filename

      git commit -m "Update branch $branch"
    done

    git checkout $currentBranch
  }

  pushtouchbranch() {
    touchbranch $*

    git push origin $*
  }
fi

