#!/usr/bin/env bash
# bootstrap.sh — brand-new-Mac entry point. Gets from zero to a working
# dotfiles checkout, then hands off to install.sh.
#
#   Run on a fresh machine:
#     /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Shivanshu-Verma/dotfiles/main/bootstrap.sh)"
#   or, if you've already cloned:
#     ./bootstrap.sh
set -euo pipefail

REPO="${DOTFILES_REPO:-https://github.com/Shivanshu-Verma/dotfiles.git}"
DEST="${HOME}/dotfiles"

info() { printf "\033[36m==>\033[0m %s\n" "$1"; }

# 1. Xcode Command Line Tools (git, compilers) -----------------------------
if ! xcode-select -p >/dev/null 2>&1; then
  info "Installing Xcode Command Line Tools (follow the GUI prompt)…"
  xcode-select --install || true
  echo "Re-run bootstrap.sh once the CLT install finishes."
  exit 0
fi

# 2. Homebrew ---------------------------------------------------------------
if ! command -v brew >/dev/null 2>&1; then
  info "Installing Homebrew…"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
# arch-aware shellenv for the rest of this script
if [[ -x /opt/homebrew/bin/brew ]]; then eval "$(/opt/homebrew/bin/brew shellenv)";
elif [[ -x /usr/local/bin/brew ]]; then eval "$(/usr/local/bin/brew shellenv)"; fi

# 3. Clone the dotfiles -----------------------------------------------------
if [[ ! -d "$DEST" ]]; then
  info "Cloning dotfiles → $DEST"
  git clone "$REPO" "$DEST"
else
  info "dotfiles already present at $DEST — pulling latest"
  git -C "$DEST" pull --ff-only || true
fi

# 4. Packages (opt-in but recommended on a fresh machine) -------------------
read -r -p "Install Homebrew packages from Brewfile now? [y/N] " ans
if [[ "$ans" =~ ^[Yy]$ ]]; then
  brew bundle --file "$DEST/Brewfile"
fi

# 5. Symlinks + config ------------------------------------------------------
info "Running install.sh"
bash "$DEST/install.sh"

# 6. Security ---------------------------------------------------------------
read -r -p "Run security setup (SSH key + Keychain) now? [y/N] " ans
if [[ "$ans" =~ ^[Yy]$ ]]; then
  bash "$DEST/scripts/security-setup.sh"
fi

info "Bootstrap complete. Open a new terminal (or 'exec zsh')."
