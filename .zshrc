# Skip all this for non-interactive shells
[[ -z "$PS1" ]] && return

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
# Aliases
#############################
# List direcory contents
alias ls='ls -h --color --group-directories-first'
alias l='ls -F'
alias ll='ls -lF'
alias la='ls -lAF'
alias lx='ls -lXB'
alias lk='ls -lSr'
alias lt='ls -lAFtr'
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
# Completions
#############################

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

#############################
# Load plugins
#############################
# enable fuzzy finder if it exists
if [[ -f ~/.fzf.zsh ]] ; then
  source ~/.fzf.zsh
  export FZF_DEFAULT_OPTS="-m --cycle"
  (( $+commands[ag] )) && export FZF_DEFAULT_COMMAND='ag -l -g ""'
fi

if ! [[ -f "${HOME}/.zplug/zplug" ]]; then
  echo "Downloading zplug..."
  curl --progress-bar -fLo "${HOME}/.zplug/zplug" --create-dirs https://git.io/zplug
fi
source "${HOME}/.zplug/zplug"

zplug "mafredri/zsh-async", of:"*.plugin.zsh", nice:-20
zplug "leomao/zsh-hooks", of:"*.plugin.zsh", nice:-20
zplug "zsh-users/zsh-completions", of:"*.plugin.zsh", nice:-10
zplug "leomao/vim.zsh", of:vim.zsh
zplug "leomao/pika-prompt", of:pika-prompt.zsh
zplug "zsh-users/zsh-syntax-highlighting", of:"*.plugin.zsh", nice:15

if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
fi

zplug load

# load custom settings
if [[ -f ~/.zshrc_custom ]]; then
  source ~/.zshrc_custom
fi
