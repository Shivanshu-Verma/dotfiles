# paths.zsh — single source of truth for PATH + language version managers
# ---------------------------------------------------------------------------
# `typeset -U path` keeps $path (and thus $PATH) de-duplicated automatically,
# so we can prepend freely without worrying about repeats.

typeset -U path PATH

# Highest priority first. Directories that don't exist are simply ignored by
# most tools, but we guard the important ones for cleanliness.
path=(
  "$HOME/.local/bin"          # pipx, claude, user-installed CLIs
  "$PNPM_HOME/bin"            # pnpm global bins (nest, etc.) — PNPM_HOME set in exports.zsh
  "$GOBIN"                    # go install targets (if Go is used)
  "$PYENV_ROOT/bin"           # pyenv itself
  "$HOME/.cargo/bin"          # rust (if installed)
  $path                       # existing PATH (brew already added in .zprofile)
)

# --- pyenv (Python version manager), lazy-loaded --------------------------
# `pyenv init -` costs ~250ms because it spawns a subprocess and sets up
# completions + rehash on every shell. We avoid that: put the shims on PATH
# immediately (so a pyenv-selected python resolves correctly), then run the
# full init only the first time `pyenv` is actually invoked.
if command -v pyenv >/dev/null 2>&1 || [[ -d "$PYENV_ROOT" ]]; then
  path=("$PYENV_ROOT/bin" "$PYENV_ROOT/shims" $path)
  pyenv() {
    unset -f pyenv
    eval "$(command pyenv init - zsh)"
    pyenv "$@"
  }
fi

# --- fnm (Node version manager) -------------------------------------------
# --use-on-cd switches Node automatically when entering a dir with .nvmrc /
# .node-version. Fast; safe to run on every interactive shell.
if command -v fnm >/dev/null 2>&1; then
  eval "$(fnm env --use-on-cd --shell zsh)"
fi

export PATH
