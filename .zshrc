# Skip all this for non-interactive shells
[[ -z "$PS1" ]] && return

if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  SSH_REMOTE=remote/ssh
else
  case $(ps -o comm= -p $PPID) in
    sshd|*/sshd) SSH_REMOTE=remote/ssh;;
  esac
fi

# don't record duplicate history
setopt HIST_IGNORE_DUPS

# no flow control
stty stop undef
stty start undef
setopt noflowcontrol

# rm confirmation
setopt RM_STAR_WAIT

# Directory Stack settings
DIRSTACKSIZE=8
setopt AUTO_CD
setopt autopushd pushdminus pushdsilent pushdtohome

# Title
case $TERM in
sun-cmd)
precmd () { print -Pn "\e]l%~\e\\" }
preexec () { print -Pn "\e]l%~\e\\" }
;;
*xterm*|rxvt|(dt|k|E)term)
precmd () { print -Pn "\e]2;%n@%m:%~\a" }
preexec () { print -Pn "\e]2;%n@%m:%~\a" }
;;
screen*)
precmd () { print -Pn "\e]2;%n@%m:%~\a" }
preexec () { print -Pn "\e]2;%n@%m:%~\a" }
;;
esac

# Prompt
autoload -U promptinit && promptinit
autoload -U colors && colors
#prompt walters
if [[ -n "$SSH_REMOTE" ]]; then
  PROMPT="%n@%{$fg[red]%}%m %{$fg[cyan]%}(ssh) %{$reset_color%}in %{$fg[green]%}%3~ 
%{$fg[blue]%}%# %{$reset_color%}>> "
else
  PROMPT="%n@%{$fg[red]%}%m %{$reset_color%}in %{$fg[green]%}%3~ 
%{$fg[blue]%}%# %{$reset_color%}>> "
fi
RPROMPT="%{$fg[magenta]%}%(?..[%?] )%{$reset_color%}"
#############################
# Bind Key
#############################
bindkey -v
bindkey "^W" backward-kill-word    # vi-backward-kill-word
bindkey "^H" backward-delete-char  # vi-backward-delete-char
bindkey "^U" backward-kill-line 
bindkey "^?" backward-delete-char  # vi-backward-delete-char

# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -A key

key[Home]=${terminfo[khome]}
key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}

# setup key accordingly
[[ -n "${key[Home]}"     ]]  && bindkey  "${key[Home]}"     beginning-of-line
[[ -n "${key[End]}"      ]]  && bindkey  "${key[End]}"      end-of-line
[[ -n "${key[Insert]}"   ]]  && bindkey  "${key[Insert]}"   overwrite-mode
[[ -n "${key[Delete]}"   ]]  && bindkey  "${key[Delete]}"   delete-char
[[ -n "${key[Up]}"       ]]  && bindkey  "${key[Up]}"       up-line-or-history
[[ -n "${key[Down]}"     ]]  && bindkey  "${key[Down]}"     down-line-or-history
[[ -n "${key[Left]}"     ]]  && bindkey  "${key[Left]}"     backward-char
[[ -n "${key[Right]}"    ]]  && bindkey  "${key[Right]}"    forward-char
[[ -n "${key[PageUp]}"   ]]  && bindkey  "${key[PageUp]}"   beginning-of-buffer-or-history
[[ -n "${key[PageDown]}" ]]  && bindkey  "${key[PageDown]}" end-of-buffer-or-history

bindkey "^R" history-beginning-search-backward
bindkey "^F" history-beginning-search-forward

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-init () {
        printf '%s' "${terminfo[smkx]}"
    }
    function zle-line-finish () {
        printf '%s' "${terminfo[rmkx]}"
    }
    zle -N zle-line-init
    zle -N zle-line-finish
fi

#############################
# Alias
#############################
# List direcory contents
alias ls='ls --color --group-directories-first'
alias l='ls -F'
alias ll='ls -lhF'
alias la='ls -lhAF'
alias lt='ls -lhtAF'
alias sl=ls # often screw this up

alias less='less -R'

# Show history
alias history='fc -l 1'

# Tmux 256 default
alias tmux='tmux -2'

# Directory Stack alias
alias dirs="dirs -v"
alias ds="dirs"

[[ -f ~/.zsh_custom ]] && . ~/.zsh_custom

#############################
# Completion
#############################
# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' expand prefix suffix
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' list-suffixes true
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]} r:|[._-]=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'
zstyle ':completion:*' menu select=0
zstyle ':completion:*' preserve-prefix '//[^/]##/'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle :compinstall filename '/home/leomao/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

#Env settings

export EDITOR="vim"
# export TERM=xterm

export LANG=zh_TW.UTF-8
export LC_CTYPE=zh_TW.UTF-8
export LC_MESSAGES=en_US.UTF-8

if (( $+commands[ruby] )) ; then
  PATH="`ruby -rubygems -e 'puts Gem.user_dir'`/bin:$PATH"
  export GEM_HOME=$(ruby -e 'puts Gem.user_dir')
fi

if (( $+commands[npm] )) ; then
  PATH=~/.node_modules/bin:$PATH
  export npm_config_prefix=~/.node_modules
  # eval "$(npm completion 2>/dev/null)"
fi

