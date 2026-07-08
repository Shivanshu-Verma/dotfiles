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
brew "poppler"      # PDF utilities (pdftotext, pdfinfo …)

# Modern replacements
brew "bat"          # cat with syntax highlighting
brew "eza"          # modern ls
brew "fd"           # modern find
brew "ripgrep"      # modern grep
brew "fzf"          # fuzzy finder
brew "zoxide"       # smarter cd
brew "starship"     # prompt

# Zsh plugins
brew "zsh-autosuggestions"       # inline greyed-out command suggestions
brew "zsh-syntax-highlighting"   # colorize valid/invalid commands as you type

# Dev tooling
brew "lazygit"      # git TUI
brew "htop"         # process viewer
brew "tmux"         # terminal multiplexer
brew "neovim"       # editor
brew "fastfetch"    # system info (fast neofetch)

# Version managers
brew "pyenv"        # python versions  (NB: run `pyenv install 3.13` after — see REPLICATION.md)
brew "fnm"          # node versions    (NB: run `fnm install --lts` after)

# Kubernetes
# NB: on THIS machine kubectl currently comes bundled with Docker Desktop, not
# brew. Keeping the formula makes kubectl reproducible & independent of Docker.
brew "kubernetes-cli"   # kubectl

# Cloud
brew "awscli"       # AWS CLI

# Fonts
cask "font-jetbrains-mono"
cask "font-jetbrains-mono-nerd-font"

# GUI apps — currently installed on this machine (some were installed manually;
# listed here so `brew bundle` reproduces them on the new laptop).
cask "iterm2"
cask "visual-studio-code"
cask "docker"               # Docker Desktop (also provides kubectl)
cask "postman"
cask "dbeaver-community"    # database GUI
cask "obsidian"
cask "slack"
cask "google-chrome"
cask "claude"              # Claude desktop app
cask "spotify"
cask "whatsapp"            # WhatsApp desktop
cask "wispr-flow"          # voice dictation

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
# brew "terraform"
# cask "google-cloud-sdk"

# --- Productivity apps ---
# cask "raycast"            # launcher / clipboard / window mgmt
# cask "rectangle"          # window snapping
# cask "orbstack"           # lighter/faster Docker & Linux VMs than Docker Desktop
# cask "visual-studio-code"
