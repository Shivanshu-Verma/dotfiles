# iTerm2 setup

iTerm2 is configured through a **Dynamic Profile** (version-controlled JSON that
iTerm2 auto-loads and hot-reloads) plus a small set of app-level settings and
zsh shell integration. This is reproducible and survives app restarts — unlike
raw `defaults write`, which iTerm2 overwrites from memory when it quits.

## Files
| File | Role |
|---|---|
| [`../iterm2/Profiles.json`](../iterm2/Profiles.json) | The full profile (font, colors, transparency, cursor, scrollback, option keys). Symlinked to `~/Library/Application Support/iTerm2/DynamicProfiles/dotfiles.json`. |
| [`../iterm2/iterm2_shell_integration.zsh`](../iterm2/iterm2_shell_integration.zsh) | Official iTerm2 shell integration (prompt marks, status, `it2*` tools). |
| [`../iterm2/apply-global-settings.sh`](../iterm2/apply-global-settings.sh) | App-level plist settings + makes the profile default. Run while iTerm2 is quit. |
| [`../zsh/iterm2.zsh`](../zsh/iterm2.zsh) | Sources shell integration (only inside iTerm2) + word-nav keybindings. |

## What the profile sets
- **Font:** JetBrains Mono Nerd Font Mono (`JetBrainsMonoNFM-Regular`) 14pt, **ligatures on**, Powerline glyphs.
- **Colors:** Tokyo Night (Storm) — full 16-color ANSI palette + cursor/selection/link.
- **Window:** 8% transparency + heavy blur (frosted glass), 120×32 default size.
- **Cursor:** solid block, no blink.
- **Scrollback:** unlimited.
- **Option keys:** send Esc+ (meta) so word-navigation, `fzf` Alt-C, and readline meta bindings work.
- **Bell:** silenced (visual only). Sessions reuse the previous pane's directory.

## Word navigation & editing (zsh/iterm2.zsh)
With the Option-as-meta setting above, these work in the shell:
- **Option + ←/→** — move by word
- **Option + Delete** — delete previous word
- **Ctrl + ←/→** — move by word (alt encoding)
- **Ctrl-A / Ctrl-E** — start / end of line · **Ctrl-U** — delete to line start

## Applying it

1. **Install (already done by `install.sh`):** symlinks the dynamic profile. iTerm2
   picks it up **live** — open Settings → Profiles and you'll see
   **"Shivanshu — Tokyo Night"**.

2. **Make it the default + apply app settings.** Because iTerm2 rewrites its
   plist on quit, do this while it's closed:
   ```bash
   # Quit iTerm2 completely (Cmd-Q), then from another terminal:
   bash ~/dotfiles/iterm2/apply-global-settings.sh
   # Re-open iTerm2 — new windows use the profile.
   ```
   *Or* the quick manual way: Settings → Profiles → select the profile →
   **Other Actions ▾ → Set as Default**.

3. **Shell integration** loads automatically the next time you open a shell
   inside iTerm2 (`exec zsh` or a new tab). It's skipped in other terminals.

## Verify
```bash
bash ~/dotfiles/scripts/doctor.sh   # see the "iTerm2" section
```

## Customizing
Edit `iterm2/Profiles.json` and save — iTerm2 reloads it instantly (no restart).
To change the color scheme, swap the `Ansi N Color` / `Background`/`Foreground`
values. To tweak transparency, adjust `"Transparency"` (0–1) and `"Blur Radius"`.

> If iTerm2 doesn't show the profile, it may not follow the symlink on your
> build — in that case copy instead of link:
> `cp ~/dotfiles/iterm2/Profiles.json "~/Library/Application Support/iTerm2/DynamicProfiles/dotfiles.json"`.
