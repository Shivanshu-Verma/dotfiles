# plugins.zsh — third-party zsh plugins. Loaded LAST (after iterm2) because
# zsh-syntax-highlighting must be sourced after all other widgets/keybindings.
# ---------------------------------------------------------------------------
# Installed via Homebrew (see Brewfile). Resolve the prefix once so this works
# on both Intel (/usr/local) and Apple Silicon (/opt/homebrew).

_brew_prefix="$(brew --prefix 2>/dev/null)"

# --- zsh-autosuggestions (inline greyed-out suggestions from history) -------
# Must load before syntax-highlighting.
_zsh_autosuggestions="${_brew_prefix}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
[[ -r "$_zsh_autosuggestions" ]] && source "$_zsh_autosuggestions"

# --- zsh-syntax-highlighting (colorize commands as you type) ----------------
# MUST be the very last thing sourced in the interactive shell.
_zsh_syntax_highlighting="${_brew_prefix}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
[[ -r "$_zsh_syntax_highlighting" ]] && source "$_zsh_syntax_highlighting"

unset _brew_prefix _zsh_autosuggestions _zsh_syntax_highlighting
