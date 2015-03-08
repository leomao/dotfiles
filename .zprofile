export EDITOR="vim"
export TERM=xterm

export LANG=zh_TW.UTF-8
export LC_CTYPE=zh_TW.UTF-8

if (( $+commands[ruby] )) ; then
  PATH="`ruby -rubygems -e 'puts Gem.user_dir'`/bin:$PATH"
  export GEM_HOME=$(ruby -e 'puts Gem.user_dir')
fi

if (( $+commands[npm] )) ; then
  PATH=~/.node_modules/bin:$PATH
  export npm_config_prefix=~/.node_modules
  eval "$(npm completion 2>/dev/null)"
fi
