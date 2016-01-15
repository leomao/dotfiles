# LC_COLLATE set to C to make ls sort by alphanumeric
export LANG=en_US.UTF-8
export LC_COLLATE=C

export KEYTIMEOUT=1
export EDITOR="vim"

# less
export LESS='-R -f -X -i -P ?f%f:(stdin). ?lb%lb?L/%L.. [?eEOF:?pb%pb\%..]'
export LESSCHARSET='utf-8'

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

if [[ -f ~/.zshenv_custom ]]; then
  source ~/.zshenv_custom
fi
