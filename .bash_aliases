### Basic unix commands

alias j='jobs'

# Temporary to break my "ls" muscle memory
# Also note: if '*' annotations become too common, bring back "--file-type"
# alias ls='ls -GAhvF --color=auto --group-directories-first --file-type'
# alias l='ls'
# alias ll='ls -l'
alias ls='echo \! && false'
alias l='/bin/ls -GAhvF --color=auto --group-directories-first'
alias ll='/bin/ls -l -GAhvF --color=auto --group-directories-first'

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

alias log='git log --decorate'
alias log1='git log -1 --decorate'
alias log2='git log -2 --decorate'
alias log3='git log -3 --decorate'
alias log5='git log -5 --decorate'
alias log9='git log -9 --decorate'
