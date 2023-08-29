ZSHRC_DIR=${${(%):-%N}:A:h}
# source command override technique
function source {
  ensure_zcompiled $1
  builtin source $1
}
function ensure_zcompiled {
  local compiled="$1.zwc"
  if [[ ! -r "$compiled" || "$1" -nt "$compiled" ]]; then
    echo "\033[1;36mCompiling\033[m $1"
    zcompile $1
  fi
}
ensure_zcompiled ~/.zshrc

# sheldon cache technique
export SHELDON_CONFIG_DIR="$ZSHRC_DIR/sheldon"
cache_dir=${XDG_CACHE_HOME:-$HOME/.cache/zsh}
sheldon_cache="$cache_dir/sheldon.zsh"
sheldon_toml="$SHELDON_CONFIG_DIR/plugins.toml"
if [[ ! -r "$sheldon_cache" || "$sheldon_toml" -nt "$sheldon_cache" ]]; then
  mkdir -p $cache_dir
  sheldon source > $sheldon_cache
fi
source "$sheldon_cache"
unset cache_dir sheldon_cache sheldon_toml

source $ZSHRC_DIR/nonlazy.zsh
zsh-defer source $ZSHRC_DIR/lazy.zsh
zsh-defer unfunction source
