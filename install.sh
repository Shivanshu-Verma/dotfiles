#!/usr/bin/env bash
# install.sh — idempotent installer. Symlinks dotfiles into $HOME, backing up
# any real files it would replace. Safe to run repeatedly.
#
#   Usage: ./install.sh
#
# It does NOT install Homebrew packages (see Brewfile) or change git identity.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

info() { printf "\033[36m==>\033[0m %s\n" "$1"; }

# link SRC DEST — back up a real DEST, then symlink SRC->DEST idempotently.
link() {
  local src="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [[ -L "$dest" && "$(readlink "$dest")" == "$src" ]]; then
    printf "  = %s (already linked)\n" "$dest"; return
  fi
  if [[ -e "$dest" && ! -L "$dest" ]]; then
    bash "$DOTFILES/scripts/backup.sh" "$dest"     # timestamped backup
  fi
  ln -sfn "$src" "$dest"
  printf "  → %s\n" "$dest"
}

# Capture any existing git identity BEFORE we replace ~/.gitconfig with our
# symlink (the new config has no [user] section, so reading it later is empty).
EXISTING_GIT_NAME="$(git config --global user.name  2>/dev/null || true)"
EXISTING_GIT_EMAIL="$(git config --global user.email 2>/dev/null || true)"

info "Linking shell config"
link "$DOTFILES/zsh/zshrc"    "$HOME/.zshrc"
link "$DOTFILES/zsh/zprofile" "$HOME/.zprofile"

info "Linking git config"
link "$DOTFILES/git/gitconfig"        "$HOME/.gitconfig"
link "$DOTFILES/git/gitignore_global" "$HOME/.gitignore_global"
link "$DOTFILES/git/gitmessage"       "$HOME/.gitmessage"

info "Linking tmux / starship"
link "$DOTFILES/tmux/tmux.conf"        "$HOME/.tmux.conf"
link "$DOTFILES/starship/starship.toml" "$HOME/.config/starship.toml"

info "Linking Claude conventions"
link "$DOTFILES/claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"

# --- iTerm2 dynamic profile (auto-loaded live by iTerm2) --------------------
if [[ -d "/Applications/iTerm.app" ]]; then
  info "Linking iTerm2 dynamic profile"
  link "$DOTFILES/iterm2/Profiles.json" \
       "$HOME/Library/Application Support/iTerm2/DynamicProfiles/dotfiles.json"
fi

# --- Seed ~/.gitconfig.local (untracked identity) --------------------------
if [[ ! -f "$HOME/.gitconfig.local" ]]; then
  info "Seeding ~/.gitconfig.local from existing git identity"
  name="$EXISTING_GIT_NAME"
  email="$EXISTING_GIT_EMAIL"
  {
    echo "[user]"
    echo "	name = ${name:-Your Name}"
    echo "	email = ${email:-you@example.com}"
  } > "$HOME/.gitconfig.local"
  printf "  → ~/.gitconfig.local (name='%s' email='%s')\n" "${name:-?}" "${email:-?}"
else
  printf "  = ~/.gitconfig.local (kept)\n"
fi

# --- VS Code `code` CLI (link only; app must already be installed) ---------
if [[ -d "/Applications/Visual Studio Code.app" && ! -x "$HOME/.local/bin/code" ]]; then
  info "Linking VS Code 'code' CLI into ~/.local/bin"
  mkdir -p "$HOME/.local/bin"
  ln -sfn "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" "$HOME/.local/bin/code"
  printf "  → ~/.local/bin/code\n"
fi

# --- VS Code user settings (macOS path) ------------------------------------
VSCODE_USER="$HOME/Library/Application Support/Code/User"
if [[ -d "/Applications/Visual Studio Code.app" ]]; then
  info "Linking VS Code settings"
  link "$DOTFILES/vscode/settings.json" "$VSCODE_USER/settings.json"
fi

# --- Sublime Text `subl` CLI (link only; app must already be installed) -----
if [[ -d "/Applications/Sublime Text.app" && ! -x "$HOME/.local/bin/subl" ]]; then
  info "Linking Sublime Text 'subl' CLI into ~/.local/bin"
  mkdir -p "$HOME/.local/bin"
  ln -sfn "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" "$HOME/.local/bin/subl"
  printf "  → ~/.local/bin/subl\n"
fi

# --- Sublime Text user config (settings + bundled Tokyo Night scheme) -------
SUBLIME_USER="$HOME/Library/Application Support/Sublime Text/Packages/User"
if [[ -d "/Applications/Sublime Text.app" ]]; then
  info "Linking Sublime Text settings"
  link "$DOTFILES/sublime/Preferences.sublime-settings" \
       "$SUBLIME_USER/Preferences.sublime-settings"
  link "$DOTFILES/sublime/tokyonight_storm.sublime-color-scheme" \
       "$SUBLIME_USER/tokyonight_storm.sublime-color-scheme"
fi

echo
info "Done linking. Next steps (not automated):"
cat <<'EOF'
  • Reload your shell:            exec zsh
  • Validate everything:         bash ~/dotfiles/scripts/doctor.sh
  • (opt-in) install packages:   brew bundle --file ~/dotfiles/Brewfile
  • (opt-in) macOS tweaks:       bash ~/dotfiles/macos/defaults.sh
  • (opt-in) tmux plugins:       git clone https://github.com/tmux-plugins/tpm \
                                   ~/.tmux/plugins/tpm  (then prefix+I in tmux)
  • (opt-in) VS Code extensions: xargs -n1 code --install-extension \
                                   < ~/dotfiles/vscode/extensions.txt
EOF
