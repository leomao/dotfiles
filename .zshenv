export EDITOR="vim"
export TERM=xterm

export LANG=zh_TW.UTF-8
export LC_CTYPE=zh_TW.UTF-8

if ! type "$ruby" > /dev/null ; then
  PATH="`ruby -rubygems -e 'puts Gem.user_dir'`/bin:$PATH"
  export GEM_HOME=$(ruby -e 'puts Gem.user_dir')
fi

if ! type "$npm" > /dev/null ; then
  PATH=~/.node_modules/bin:$PATH
  export npm_config_prefix=~/.node_modules
fi
