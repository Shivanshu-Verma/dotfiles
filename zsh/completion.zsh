# completion.zsh — zsh completion system, tuned for speed.
# ---------------------------------------------------------------------------
# Strategy: cache tool-generated completions to files in fpath (regenerated at
# most weekly), THEN run compinit once (rebuilding its dump at most daily).
# This keeps every startup free of completion-subprocess spawns.

# --- 1. Cache tool completions into an fpath dir (before compinit) ---------
# `source <(tool completion zsh)` on every startup costs ~150-200ms (a
# subprocess each). We write them to files instead and let compinit pick
# them up, regenerating only when missing or older than 7 days.
_comp_cache="${HOME}/.cache/zsh/completions"
mkdir -p "$_comp_cache"
fpath=("$_comp_cache" $fpath)

# _cache_completion <name> <command...>  -> writes $_comp_cache/_<name>
_cache_completion() {
  local name="$1"; shift
  local dest="$_comp_cache/_$name"
  # (#qN.mh+168) => older than 168h (7 days); also (re)build if missing/empty.
  if [[ ! -s "$dest" || -n "$dest"(#qN.mh+168) ]]; then
    "$@" > "$dest" 2>/dev/null || rm -f "$dest"
  fi
}
command -v kubectl >/dev/null 2>&1 && _cache_completion kubectl kubectl completion zsh
command -v docker  >/dev/null 2>&1 && _cache_completion docker  docker  completion zsh
command -v gh      >/dev/null 2>&1 && _cache_completion gh      gh      completion -s zsh
unset -f _cache_completion
unset _comp_cache

# --- 2. compinit (rebuild dump at most once per 24h) -----------------------
autoload -Uz compinit
_zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
if [[ -n "$_zcompdump"(#qN.mh+24) ]]; then
  compinit -d "$_zcompdump"      # full run: rebuild the dump
else
  compinit -C -d "$_zcompdump"   # fast path: trust the existing dump
fi
unset _zcompdump

# --- 3. Completion styling -------------------------------------------------
zstyle ':completion:*' menu select                         # arrow-key menu
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'  # case-insensitive
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"    # colorize matches
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{yellow}%d%f'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${HOME}/.cache/zsh/compcache"

# Make the `k` alias complete like kubectl.
command -v kubectl >/dev/null 2>&1 && compdef k=kubectl 2>/dev/null
