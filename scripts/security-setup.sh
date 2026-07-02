#!/usr/bin/env bash
# security-setup.sh — one-time security hardening. Idempotent & non-destructive:
#   • Generates an ed25519 SSH key (only if none exists).
#   • Writes ~/.ssh/config with Keychain + agent integration.
#   • Ensures git uses the macOS Keychain and removes any plaintext credentials.
#
#   Usage: bash ~/dotfiles/security-setup.sh ["Key comment / email"]
set -euo pipefail

info() { printf "\033[36m==>\033[0m %s\n" "$1"; }

# Effective config (not --global): identity may live in ~/.gitconfig.local,
# which some git builds don't traverse for --global reads.
EMAIL="${1:-$(git config user.email 2>/dev/null)}"
EMAIL="${EMAIL:-$(whoami)@$(hostname)}"
SSH_DIR="$HOME/.ssh"
KEY="$SSH_DIR/id_ed25519"

mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"

# --- SSH key --------------------------------------------------------------
if [[ -f "$KEY" ]]; then
  info "SSH key already exists ($KEY) — leaving it untouched."
else
  info "Generating ed25519 SSH key for '$EMAIL'"
  # No passphrase for a smooth workstation flow; add one later with:
  #   ssh-keygen -p -f ~/.ssh/id_ed25519
  ssh-keygen -t ed25519 -C "$EMAIL" -f "$KEY" -N ""
fi
chmod 600 "$KEY" 2>/dev/null || true
chmod 644 "$KEY.pub" 2>/dev/null || true

# --- SSH config (append our managed block once) ---------------------------
if ! grep -q "# --- managed by dotfiles ---" "$SSH_DIR/config" 2>/dev/null; then
  info "Writing ~/.ssh/config (Keychain + agent)"
  cat >> "$SSH_DIR/config" <<'EOF'
# --- managed by dotfiles ---
Host *
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519
  ServerAliveInterval 60
EOF
  chmod 600 "$SSH_DIR/config"
else
  info "~/.ssh/config already has managed block — skipping."
fi

# --- Load key into agent + Keychain ---------------------------------------
info "Adding key to ssh-agent / Keychain"
ssh-add --apple-use-keychain "$KEY" 2>/dev/null || ssh-add "$KEY" 2>/dev/null || true

# --- Git credentials -> Keychain, remove plaintext ------------------------
info "Ensuring git credential.helper = osxkeychain"
git config --global credential.helper osxkeychain
if [[ -f "$HOME/.git-credentials" ]]; then
  info "Removing plaintext ~/.git-credentials (backed up first)"
  cp -a "$HOME/.git-credentials" "$HOME/.git-credentials.$(date +%Y%m%d-%H%M%S).bak"
  rm -f "$HOME/.git-credentials"
fi

echo
info "Public key (add to GitHub → Settings → SSH keys):"
echo
cat "$KEY.pub"
echo
info "Test with:  ssh -T git@github.com"
