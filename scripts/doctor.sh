#!/usr/bin/env bash
# doctor.sh — validate the environment after install. Non-destructive.
# Exits non-zero if any critical check fails.
set -uo pipefail

pass=0; fail=0; warn=0
ok()   { printf "  \033[32m✓\033[0m %s\n" "$1"; pass=$((pass+1)); }
bad()  { printf "  \033[31m✗\033[0m %s\n" "$1"; fail=$((fail+1)); }
note() { printf "  \033[33m•\033[0m %s\n" "$1"; warn=$((warn+1)); }

link_ok() { # link_ok <path> <expected-target-substring>
  if [[ -L "$1" && "$(readlink "$1")" == *"$2"* ]]; then ok "symlink $1"; else bad "symlink $1 (expected -> …$2)"; fi
}

echo "== Symlinks =="
link_ok "$HOME/.zshrc"            "dotfiles/zsh/zshrc"
link_ok "$HOME/.zprofile"         "dotfiles/zsh/zprofile"
link_ok "$HOME/.gitconfig"        "dotfiles/git/gitconfig"
link_ok "$HOME/.gitignore_global" "dotfiles/git/gitignore_global"
link_ok "$HOME/.gitmessage"       "dotfiles/git/gitmessage"
link_ok "$HOME/.tmux.conf"        "dotfiles/tmux/tmux.conf"
link_ok "$HOME/.config/starship.toml" "dotfiles/starship/starship.toml"
link_ok "$HOME/.claude/CLAUDE.md" "dotfiles/claude/CLAUDE.md"

echo "== Interactive shell (fresh) =="
# Run a fresh interactive zsh and inspect the resulting environment.
probe() { zsh -i -c "$1" 2>/dev/null; }
[[ "$(probe 'echo $HISTSIZE')" == "50000" ]] && ok "exports loaded (HISTSIZE)" || bad "exports not loaded"
probe 'alias ll' | grep -q eza && ok "aliases loaded (ll -> eza)" || bad "aliases not loaded"
probe 'type mkcd' | grep -q function && ok "functions loaded (mkcd)" || bad "functions not loaded"
probe 'echo $PATH' | tr ':' '\n' | grep -q "$HOME/.local/bin" && ok "PATH contains ~/.local/bin" || bad "PATH missing ~/.local/bin"
probe 'echo $PROMPT' | grep -qi starship && ok "starship prompt active" || note "starship not detected in \$PROMPT (may still work)"
probe 'type __zoxide_z' | grep -q function && ok "zoxide active (z)" || note "zoxide not active"
probe 'type fzf-history-widget' | grep -q 'function\|widget' && ok "fzf keybindings active" || note "fzf keybindings not detected"

echo "== Tools on PATH =="
for t in git gh eza bat fd rg fzf zoxide starship lazygit tmux nvim kubectl docker claude pyenv fnm node jq; do
  command -v "$t" >/dev/null 2>&1 && ok "$t" || note "$t not found"
done

echo "== Git config =="
[[ "$(git config --global credential.helper)" == "osxkeychain" ]] && ok "credential.helper = osxkeychain" || bad "credential.helper not osxkeychain"
[[ "$(git config --global pull.ff)" == "only" ]] && ok "pull.ff = only" || bad "pull.ff not set"
# NB: use effective config (not --global); this git build doesn't traverse
# includes for --global reads, and identity lives in ~/.gitconfig.local.
[[ -n "$(git config user.email)" ]] && ok "user.email set ($(git config user.email))" || bad "user.email missing"
[[ "$(git config --global core.excludesfile)" == *gitignore_global ]] && ok "global gitignore wired" || bad "global gitignore not wired"

echo "== SSH =="
if [[ -f "$HOME/.ssh/id_ed25519" ]]; then ok "ed25519 key present"; else note "no ed25519 key"; fi
[[ -f "$HOME/.ssh/config" ]] && ok "ssh config present" || note "no ssh config"

echo "== iTerm2 =="
if [[ -d "/Applications/iTerm.app" ]]; then
  _dp="$HOME/Library/Application Support/iTerm2/DynamicProfiles/dotfiles.json"
  [[ -L "$_dp" ]] && ok "dynamic profile linked" || note "dynamic profile not linked (run install.sh)"
  [[ -r "$HOME/dotfiles/iterm2/iterm2_shell_integration.zsh" ]] && ok "shell integration script present" || note "shell integration missing"
  if [[ "$(defaults read com.googlecode.iterm2 'Default Bookmark Guid' 2>/dev/null)" == "SHV-DOTFILES-TOKYONIGHT-0001" ]]; then
    ok "profile is default"
  else
    note "profile not yet default (quit iTerm2, run iterm2/apply-global-settings.sh, or set in Settings)"
  fi
else
  note "iTerm2 not installed"
fi

echo
printf "Summary: \033[32m%d passed\033[0m, \033[33m%d notes\033[0m, \033[31m%d failed\033[0m\n" "$pass" "$warn" "$fail"
[[ "$fail" -eq 0 ]]
