# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth
# append to the history file, don't overwrite it
shopt -s histappend
# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=2000000

# update the window size after each command and
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set a fancy prompt (non-color, unless we know we "want" color)

__bash_prompt() {
    local color_prompt=
    case "$TERM" in
        xterm-color|*-256color)
            color_prompt=yes;;
        *)
            if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
                color_prompt=yes
            fi;;
    esac

    if [ -n "$color_prompt" ]; then
        local user_and_xit_part='`export XIT=$? \
            && [ ! -z "${GITHUB_USER}" ] && echo -n "\[\033[0;32m\]@${GITHUB_USER} " || echo -n "\[\033[0;32m\]\u " \
            && [ "$XIT" -ne "0" ] && echo -n "\[\033[1;31m\]➜" || echo -n "\[\033[0m\]➜"`'
        local lightblue=`echo -n '\[\033[1;34m\]'`
        local removecolor=`echo -n '\[\033[0m\]'`
    else
        local user_and_xit_part='`export XIT=$? \
            && [ ! -z "${GITHUB_USER}" ] && echo -n "@${GITHUB_USER} " || echo -n "\u " \
            && [ "$XIT" -ne "0" ] && echo -n "!➜" || echo -n " ➜"`'
        local lightblue=''
        local removecolor=''
    fi

    PS1="${user_and_xit_part} ${lightblue}\w${removecolor} \$ "
    unset -f __bash_prompt
}
__bash_prompt
export PROMPT_DIRTRIM=4

# Set dircolors
if [ -x /usr/bin/dircolors ]; then
    [ -r ~/.dircolors ] && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# These cause signature verification to fail when you push to a protected branch
unset GIT_COMMITTER_EMAIL GIT_COMMITTER_NAME

