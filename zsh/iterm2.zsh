# iterm2.zsh — iTerm2 shell integration + terminal keybindings.
# ---------------------------------------------------------------------------
# Only meaningful inside iTerm2, but the keybindings are harmless anywhere.

# --- iTerm2 shell integration ---------------------------------------------
# Enables: prompt marks (jump between commands), command status, downloadable
# files (`it2dl`), current-dir reporting, and Cmd-Click semantics.
# Loaded only when actually running under iTerm2 to avoid overhead elsewhere.
if [[ "$LC_TERMINAL" == "iTerm2" || "$TERM_PROGRAM" == "iTerm.app" ]]; then
  _iterm_integration="${HOME}/dotfiles/iterm2/iterm2_shell_integration.zsh"
  [[ -r "$_iterm_integration" ]] && source "$_iterm_integration"
  unset _iterm_integration
fi

# --- Word-wise navigation & editing ---------------------------------------
# The iTerm2 profile sets both Option keys to "Esc+" (meta). These bindings
# make Option/Alt + arrows move by word, plus common readline word ops. We
# bind several encodings so it works with meta-on, xterm CSI, and Ctrl-arrow.
bindkey "^[b"        backward-word          # Option/Esc + b
bindkey "^[f"        forward-word           # Option/Esc + f
bindkey "^[^[[D"     backward-word          # Option + Left  (meta + arrow)
bindkey "^[^[[C"     forward-word           # Option + Right (meta + arrow)
bindkey "^[[1;3D"    backward-word          # Option + Left  (xterm CSI)
bindkey "^[[1;3C"    forward-word           # Option + Right (xterm CSI)
bindkey "^[[1;5D"    backward-word          # Ctrl + Left
bindkey "^[[1;5C"    forward-word           # Ctrl + Right
bindkey "^[^?"       backward-kill-word     # Option + Delete  -> delete word
bindkey "^[[H"       beginning-of-line      # Home
bindkey "^[[F"       end-of-line            # End
bindkey "^A"         beginning-of-line      # Ctrl-A
bindkey "^E"         end-of-line            # Ctrl-E
bindkey "^U"         backward-kill-line     # Ctrl-U -> delete to line start
