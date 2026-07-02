# Brewfile — declarative package manifest for this workstation.
#
# Reproduce everything with:   brew bundle --file ~/dotfiles/Brewfile
# See what's missing:          brew bundle check --file ~/dotfiles/Brewfile
# Remove anything not listed:  brew bundle cleanup --file ~/dotfiles/Brewfile
#
# NOTE: install.sh does NOT run this automatically. It documents the intended
# package set. Sections marked OPTIONAL are commented out — uncomment what you
# want, then run `brew bundle`.

# ============================ Currently installed ==========================
# Core CLI
brew "git"
brew "gh"
brew "curl"
brew "wget"
brew "jq"
brew "tree"

# Modern replacements
brew "bat"          # cat with syntax highlighting
brew "eza"          # modern ls
brew "fd"           # modern find
brew "ripgrep"      # modern grep
brew "fzf"          # fuzzy finder
brew "zoxide"       # smarter cd
brew "starship"     # prompt

# Dev tooling
brew "lazygit"      # git TUI
brew "htop"         # process viewer
brew "tmux"         # terminal multiplexer
brew "neovim"       # editor

# Version managers
brew "pyenv"        # python versions
brew "fnm"          # node versions

# Kubernetes
brew "kubernetes-cli"   # kubectl

# Fonts + apps
cask "font-jetbrains-mono"
cask "font-jetbrains-mono-nerd-font"
cask "iterm2"
cask "obsidian"
cask "postman"
cask "spotify"

# ============================ RECOMMENDED (opt-in) =========================
# Uncomment to install; see docs/DESIGN.md for rationale.

# --- Languages ---
# brew "go"                 # Go toolchain (a primary language, currently missing)
# brew "rustup"             # Rust toolchain manager

# --- Python ---
# brew "pipx"               # isolated Python CLI apps
# brew "uv"                 # fast venv/dependency manager

# --- Git / shell UX ---
# brew "git-delta"          # gorgeous diffs (wire into gitconfig core.pager)
# brew "direnv"             # per-directory env vars
# brew "gnupg"              # GPG for signed commits

# --- Kubernetes / infra ---
# brew "kubectx"            # switch contexts/namespaces fast
# brew "k9s"                # kubernetes TUI
# brew "helm"               # package manager
# brew "stern"              # multi-pod log tailing

# --- Cloud / IaC ---
# brew "awscli"
# brew "terraform"
# cask "google-cloud-sdk"

# --- Productivity apps ---
# cask "raycast"            # launcher / clipboard / window mgmt
# cask "rectangle"          # window snapping
# cask "orbstack"           # lighter/faster Docker & Linux VMs than Docker Desktop
# cask "visual-studio-code"
