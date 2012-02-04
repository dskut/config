# The following lines were added by compinstall

zstyle ':completion:*' completer _complete _ignored _approximate
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' matcher-list 'r:|[._-]=* r:|=*' 'r:|[._-]=* r:|=*'
zstyle :compinstall filename '/home/dskut/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=5000
SAVEHIST=10000
setopt appendhistory autocd
unsetopt extendedglob
bindkey -e
# End of lines configured by zsh-newuser-install

autoload -U promptinit
promptinit

autoload -U colors && colors

PROMPT="%{$fg[green]%}%n%{$reset_color%}@%{$fg[cyan]%}%m%{$reset_color%}:%{$fg[yellow]%}%~%{$reset_color%}%# "
RPROMPT="[%{$fg[green]%}%?%{$reset_color%}]"

if [ -d $HOME/bin ]; then export PATH=$PATH:$HOME/bin; fi

export EDITOR="vim"
export BROWSER="conkeror"

##################################################################
## Key bindings
## http://mundy.yazzy.org/unix/zsh.php
## http://www.zsh.org/mla/users/2000/msg00727.html

typeset -g -A key
bindkey '^?' backward-delete-char
bindkey '^[[1~' beginning-of-line
bindkey '^[[5~' up-line-or-history
bindkey '^[[3~' delete-char
bindkey '^[[4~' end-of-line
bindkey '^[[6~' down-line-or-history
bindkey '^[[A' up-line-or-search
bindkey '^[[D' backward-char
bindkey '5D' backward-word
bindkey '^[[B' down-line-or-search
bindkey '^[[C' forward-char
bindkey '5C' forward-word
bindkey '^[w' backward-delete-to-slash
# completion in the middle of a line
bindkey '^i' expand-or-complete-prefix

##################################################################
# My aliases

# Set up auto extension stuff
alias -s html=$BROWSER
alias -s gz='tar -xzvf'
alias -s bz2='tar -xjvf'

# Normal aliases
alias ls='ls --color=auto -F'
alias lsd='ls -ld *(-/DN)'
alias lsa='ls -ld .*'
alias f='find |grep'
alias c="clear"
alias dir='ls -1'
alias gvim='gvim -geom 82x35'
# alias ..='cd ..'

#################################################################
# colored man
man() {
        env \
            LESS_TERMCAP_mb=$(printf "\e[1;34m") \
            LESS_TERMCAP_md=$(printf "\e[1;31m") \
            LESS_TERMCAP_me=$(printf "\e[0m") \
            LESS_TERMCAP_se=$(printf "\e[0m") \
            LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
            LESS_TERMCAP_ue=$(printf "\e[0m") \
            LESS_TERMCAP_us=$(printf "\e[1;32m") \
                man "$@"
}

###################################################
# for work

ulimit -c unlimited
export DBGOUT=1

function set_title {
    comm="\033]0;$1\a"
    echo -e $comm
}
