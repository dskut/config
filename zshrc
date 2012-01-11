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
setopt beep
bindkey -e
# End of lines configured by zsh-newuser-install

autoload -U promptinit
promptinit

autoload -U colors && colors

PROMPT="%{$fg[green]%}%n%{$reset_color%}@%{$fg[blue]%}%m%{$reset_color%}:%{$fg[yellow]%}%~%{$reset_color%}%# "
RPROMPT="[%{$fg[green]%}%?%{$reset_color%}]"
