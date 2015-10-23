# Skip all this for non-interactive shells
[[ -z "$PS1" ]] && return

export EDITOR="vim"

#############################
# Options
#############################
# don't record duplicate history
setopt hist_ignore_dups

# no flow control
setopt noflowcontrol

# rm confirmation
setopt rm_star_wait

# Directory Stack settings
DIRSTACKSIZE=8
setopt auto_cd
setopt autopushd pushdminus pushdsilent pushdtohome

#############################
# Bind Key
#############################
bindkey -v
dir-backward-delete-word() {
  local WORDCHARS="${WORDCHARS:s#/#}"
  zle backward-delete-word
}
zle -N dir-backward-delete-word
bindkey "^W" dir-backward-delete-word    # vi-backward-kill-word
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

# vi as vim
alias vi='vim'

# Directory Stack alias
alias dirs="dirs -v"
alias ds="dirs"

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
zstyle ':completion:*' menu select=long-list
zstyle ':completion:*' preserve-prefix '//[^/]##/'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s

# End of lines added by compinstall

#############################
# Path settings
#############################
if (( $+commands[ruby] )) ; then
  if [[ -d ~/.rbenv ]] ; then
    # use rbenv if it exists
    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init -)"
  else
    # According to https://wiki.archlinux.org/index.php/Ruby#RubyGems
    export GEM_HOME=$(ruby -e 'puts Gem.user_dir')
    export PATH="${GEM_HOME}/bin:$PATH"
  fi
fi

if (( $+commands[npm] )) ; then
  export PATH="$HOME/.node_modules/bin:$PATH"
  export npm_config_prefix=~/.node_modules
fi

#############################
# Load plugins
#############################
# enable fuzzy finder if it exists
if [[ -f ~/.fzf.zsh ]] ; then
  source ~/.fzf.zsh
  export FZF_DEFAULT_OPTS="-x -m --cycle"
  (( $+commands[ag] )) && export FZF_DEFAULT_COMMAND='ag -l -g ""'
fi

if ! [[ -f "${HOME}/.zgen/zgen.zsh" ]]; then
  git clone --depth=1 https://github.com/leomao/zgen.git "${HOME}/.zgen"
fi
source "${HOME}/.zgen/zgen.zsh"

zgen load mafredri/zsh-async
zgen load leomao/pure
zgen load zsh-users/zsh-completions src

zgen compinit

# must load at the end for zle widget be set properly
zgen load zsh-users/zsh-syntax-highlighting

# load custom settings
[[ -f ~/.zshrc_custom ]] && source ~/.zshrc_custom

return 0

