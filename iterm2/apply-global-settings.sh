#!/usr/bin/env bash
# apply-global-settings.sh — app-level iTerm2 settings that live in the plist
# (not in a profile). These must be written while iTerm2 is NOT running,
# because iTerm2 rewrites its plist from memory when it quits and would clobber
# any changes made while it's open.
#
#   Usage: quit iTerm2 completely (Cmd-Q), then:  bash apply-global-settings.sh
set -euo pipefail

DOMAIN="com.googlecode.iterm2"
PROFILE_GUID="SHV-DOTFILES-TOKYONIGHT-0001"

if pgrep -x iTerm2 >/dev/null; then
  echo "✗ iTerm2 is running. Quit it completely (Cmd-Q) and re-run this script."
  echo "  (Otherwise iTerm2 will overwrite these settings when it exits.)"
  exit 1
fi

echo "==> Applying iTerm2 global settings…"

# Make our dynamic profile the default for new windows/tabs.
defaults write "$DOMAIN" "Default Bookmark Guid" -string "$PROFILE_GUID"

# --- Window / tab appearance ----------------------------------------------
# Theme: 4 = minimal (clean, no title bar chrome). 0=regular,1=compact,2=dark.
defaults write "$DOMAIN" TabStyleWithAutomaticOption -int 5      # minimal
defaults write "$DOMAIN" HideTab -bool false                    # keep tab bar
defaults write "$DOMAIN" HideTabNumber -bool false
defaults write "$DOMAIN" HideActivityIndicator -bool false
defaults write "$DOMAIN" ShowFullScreenTabBar -bool true
defaults write "$DOMAIN" StatusBarPosition -int 1               # status bar at bottom

# --- Behavior --------------------------------------------------------------
defaults write "$DOMAIN" PromptOnQuit -bool false               # no quit nag
defaults write "$DOMAIN" OnlyWhenMoreTabs -bool true            # confirm close only w/ >1 tab
defaults write "$DOMAIN" QuitWhenAllWindowsClosed -bool false
defaults write "$DOMAIN" SUEnableAutomaticChecks -bool true     # auto-update checks
defaults write "$DOMAIN" AlternateMouseScroll -bool true        # scroll wheel in alt screens (less/vim)
defaults write "$DOMAIN" ExperimentalKeyHandling -bool true
defaults write "$DOMAIN" UseBorder -bool false
defaults write "$DOMAIN" DisableFullscreenTransparency -bool false

# --- Native macOS niceties -------------------------------------------------
defaults write "$DOMAIN" UseLionStyleFullscreen -bool true      # native full screen
defaults write "$DOMAIN" AllowClipboardAccess -bool true
defaults write "$DOMAIN" SoundForEsc -bool false

echo "✓ Done. Re-open iTerm2 — new windows use 'Shivanshu — Tokyo Night'."
