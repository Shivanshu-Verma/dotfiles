# exports.zsh — environment variables & tool configuration
# ---------------------------------------------------------------------------

# --- Editor / pager -------------------------------------------------------
export EDITOR="nano"
export VISUAL="nano"
export PAGER="less"
# -R: render colors, -F: quit if one screen, -X: don't clear screen
export LESS="-RFX"

# --- Locale ----------------------------------------------------------------
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# --- History ---------------------------------------------------------------
export HISTFILE="${HOME}/.zsh_history"
export HISTSIZE=50000          # lines kept in memory
export SAVEHIST=50000          # lines written to $HISTFILE
setopt HIST_IGNORE_DUPS        # don't record an entry that duplicates the last
setopt HIST_IGNORE_ALL_DUPS    # delete older duplicate entries
setopt HIST_IGNORE_SPACE       # commands starting with a space are not recorded
setopt HIST_REDUCE_BLANKS      # trim superfluous whitespace
setopt SHARE_HISTORY           # share history across concurrent sessions
setopt INC_APPEND_HISTORY      # write immediately, not on shell exit
setopt EXTENDED_HISTORY        # record timestamps

# --- Navigation / misc quality-of-life ------------------------------------
setopt AUTO_CD                 # `foo/` == `cd foo/`
setopt AUTO_PUSHD              # cd pushes onto the dir stack
setopt PUSHD_IGNORE_DUPS
setopt INTERACTIVE_COMMENTS    # allow `# comments` in interactive shell
setopt NO_BEEP

# --- Tool configuration ----------------------------------------------------
# bat: theme + use as the man pager (colorized man pages)
export BAT_THEME="ansi"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"

# fzf: default command uses fd (respects .gitignore, skips .git), nice UI
if command -v fd >/dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
fi
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --info=inline"

# less/keychain-friendly SSH
export GPG_TTY="$(tty 2>/dev/null)"

# Go (used only if Go is installed; harmless otherwise)
export GOPATH="${HOME}/go"
export GOBIN="${GOPATH}/bin"

# pyenv root (default location)
export PYENV_ROOT="${HOME}/.pyenv"
