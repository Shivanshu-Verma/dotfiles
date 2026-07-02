#!/usr/bin/env bash
# macos/defaults.sh — OPT-IN macOS system tweaks. Not run by install.sh.
# Review each block, then run:  bash ~/dotfiles/macos/defaults.sh
# Some changes need a logout or `killall Finder/Dock` to take effect.
set -euo pipefail

echo "Applying macOS developer defaults..."

# --- Keyboard: fast key repeat (huge win for terminal/vim users) ----------
defaults write NSGlobalDomain KeyRepeat -int 2          # fast repeat
defaults write NSGlobalDomain InitialKeyRepeat -int 15  # short delay
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false  # repeat, not accent popup

# --- Finder ----------------------------------------------------------------
defaults write com.apple.finder AppleShowAllFiles -bool true       # show dotfiles
defaults write NSGlobalDomain AppleShowAllExtensions -bool true    # show extensions
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"  # list view
defaults write com.apple.finder _FXSortFoldersFirst -bool true
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"  # search current folder
# Don't litter network/USB volumes with .DS_Store
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# --- Dock ------------------------------------------------------------------
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock tilesize -int 44

# --- Screenshots to ~/Screenshots ----------------------------------------
mkdir -p "${HOME}/Screenshots"
defaults write com.apple.screencapture location -string "${HOME}/Screenshots"
defaults write com.apple.screencapture type -string "png"

echo "Restarting Finder and Dock..."
killall Finder Dock 2>/dev/null || true
echo "Done. A few settings may require logout/login."
