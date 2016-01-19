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
# Important
zstyle ':completion:*:default' menu yes=long select=2

# Completing Groping
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:descriptions' format '%F{226}Completing %F{214}%d%f'
zstyle ':completion:*' group-name ''

# Completing misc
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]} r:|[._-]=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'
zstyle ':completion:*' verbose yes
zstyle ':completion:*' completer _expand _complete _match _prefix _approximate _list _history
zstyle ':completion:*' expand prefix suffix
zstyle ':completion:*:*files' ignored-patterns '*?.o' '*?~' '*\#'
zstyle ':completion:*' use-cache true
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s

# Directory
zstyle ':completion:*:cd:*' ignore-parents parent pwd
export LS_COLORS='di=01;94:ln=01;96:ex=01;92'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# default: --
zstyle ':completion:*' list-separator '-->'
zstyle ':completion:*:manuals' separate-sections true

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
zplug "zsh-users/zsh-completions", of:"*.plugin.zsh", nice:-20
zplug "leomao/vim.zsh", of:vim.zsh, nice:-5
zplug "leomao/pika-prompt", of:pika-prompt.zsh

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
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
