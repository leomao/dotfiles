# LC_COLLATE set to C to make ls sort by alphanumeric
export LANG=en_US.UTF-8
export LC_COLLATE=C

export KEYTIMEOUT=1
export EDITOR="vim"

# less
export LESS='-RfFXi -P ?f%f:(stdin). ?lb%lb?L/%L.. [?eEOF:?pb%pb\%..]'
export LESSCHARSET='utf-8'

#############################
# Path
#############################
# see the notes below
# https://wiki.archlinux.org/index.php/Zsh#Configuring_.24PATH
typeset -U path

if (( $+commands[ruby] )) ; then
  if [[ -d ~/.rbenv ]] ; then
    # use rbenv if it exists
    path=(~/.rbenv/bin $path[@])
    eval "$(rbenv init -)"
  else
    # According to https://wiki.archlinux.org/index.php/Ruby#RubyGems
    export GEM_HOME=$(ruby -e 'puts Gem.user_dir')
    path=($GEM_HOME/bin $path[@])
  fi
fi

if (( $+commands[npm] )) ; then
  path=(~/.node_modules/bin $path[@])
  export npm_config_prefix=~/.node_modules
fi

if [[ $+commands[go] ]]; then
  export GOPATH=~/.go
  path=($GOPATH/bin $path[@])
fi

path=($path[@] "$HOME/.local/bin")

if [[ -f "${HOME}/.zshenv.local" ]]; then
  source "${HOME}/.zshenv.local"
fi
