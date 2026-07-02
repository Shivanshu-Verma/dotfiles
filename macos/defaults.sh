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

# --- Keyboard: disable "smart" text substitutions that fight code ----------
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false     # no “curly” quotes
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false      # no em-dashes
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false    # no double-space period
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false    # no autocorrect

# --- Trackpad --------------------------------------------------------------
# Tap to click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
# Three-finger drag (accessibility gesture)
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true
# Natural scrolling (setup.md: "your preference" — true = default macOS direction)
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true

# --- Finder ----------------------------------------------------------------
defaults write com.apple.finder AppleShowAllFiles -bool true       # show dotfiles
defaults write NSGlobalDomain AppleShowAllExtensions -bool true    # show extensions
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"  # list view
defaults write com.apple.finder _FXSortFoldersFirst -bool true
defaults write com.apple.finder _FXSortFoldersFirstOnDesktop -bool true
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"  # search current folder
# Show hard disks / external disks / servers on the Desktop (setup.md Finder)
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
# Show full POSIX path in the Finder title bar
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
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
