# prompt.zsh — prompt + interactive integrations. Loaded last so it wins.
# ---------------------------------------------------------------------------

# --- zoxide (smarter cd; `z <partial>` jumps to frecent dirs) -------------
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
  # `cd` stays vanilla; use `z` to jump and `zi` for interactive fzf pick.
fi

# --- fzf (fuzzy finder): key-bindings (Ctrl-R, Ctrl-T, Alt-C) + completion -
# Modern fzf (>=0.48) can emit its zsh integration directly.
if command -v fzf >/dev/null 2>&1; then
  if fzf --zsh >/dev/null 2>&1; then
    # 2>/dev/null silences a benign "can't change option: zle" that fzf emits
    # only in non-TTY scripted shells (never in a real interactive terminal).
    eval "$(fzf --zsh)" 2>/dev/null
  else
    # Fallback for older fzf installed via Homebrew.
    _fzf_base="$(brew --prefix 2>/dev/null)/opt/fzf/shell"
    [[ -r "$_fzf_base/completion.zsh"   ]] && source "$_fzf_base/completion.zsh"
    [[ -r "$_fzf_base/key-bindings.zsh" ]] && source "$_fzf_base/key-bindings.zsh"
    unset _fzf_base
  fi
fi

# --- starship prompt (must be last) ---------------------------------------
if command -v starship >/dev/null 2>&1; then
  export STARSHIP_CONFIG="${HOME}/.config/starship.toml"
  eval "$(starship init zsh)"
fi
