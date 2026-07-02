# functions.zsh — shell functions for things aliases can't express cleanly.
# ---------------------------------------------------------------------------

# mkcd DIR — make a directory (with parents) and cd into it.
mkcd() {
  [[ -z "$1" ]] && { echo "usage: mkcd <dir>"; return 1; }
  mkdir -p -- "$1" && cd -- "$1"
}

# gclone URL — clone a repo and cd into the resulting directory.
gclone() {
  [[ -z "$1" ]] && { echo "usage: gclone <git-url>"; return 1; }
  local dir
  dir="$(basename "$1" .git)"
  git clone "$1" && cd "$dir"
}

# extract FILE — extract virtually any archive by extension.
extract() {
  [[ -f "$1" ]] || { echo "extract: '$1' is not a file"; return 1; }
  case "$1" in
    *.tar.bz2|*.tbz2) tar xjf "$1" ;;
    *.tar.gz|*.tgz)   tar xzf "$1" ;;
    *.tar.xz)         tar xJf "$1" ;;
    *.tar)            tar xf  "$1" ;;
    *.bz2)            bunzip2 "$1" ;;
    *.gz)             gunzip  "$1" ;;
    *.zip)            unzip   "$1" ;;
    *.rar)            unrar x "$1" ;;
    *.7z)             7z x    "$1" ;;
    *.Z)              uncompress "$1" ;;
    *) echo "extract: don't know how to handle '$1'"; return 1 ;;
  esac
}

# killport PORT — kill whatever process is listening on a TCP port.
killport() {
  [[ -z "$1" ]] && { echo "usage: killport <port>"; return 1; }
  local pids
  pids="$(lsof -tiTCP:"$1" -sTCP:LISTEN 2>/dev/null)"
  if [[ -z "$pids" ]]; then
    echo "killport: nothing listening on port $1"; return 1
  fi
  echo "$pids" | xargs kill -9 && echo "killed pid(s) on port $1: $pids"
}

# dsh CONTAINER — open an interactive shell inside a running container
# (tries bash, falls back to sh).
dsh() {
  [[ -z "$1" ]] && { echo "usage: dsh <container>"; return 1; }
  docker exec -it "$1" sh -c 'command -v bash >/dev/null 2>&1 && exec bash || exec sh'
}

# serve [PORT] — quick static HTTP server in the current dir (default :8000).
serve() {
  local port="${1:-8000}"
  echo "Serving $(pwd) on http://localhost:${port}  (Ctrl-C to stop)"
  python3 -m http.server "$port"
}

# backup FILE — copy a file next to itself with a timestamp suffix.
backup() {
  [[ -e "$1" ]] || { echo "backup: '$1' does not exist"; return 1; }
  cp -a -- "$1" "$1.$(date +%Y%m%d-%H%M%S).bak" && echo "backed up -> $1.*.bak"
}

# venv — create (if missing) and activate a Python virtualenv in ./.venv
venv() {
  if [[ ! -d .venv ]]; then
    echo "creating .venv ..."
    python3 -m venv .venv || return 1
  fi
  source .venv/bin/activate
}
