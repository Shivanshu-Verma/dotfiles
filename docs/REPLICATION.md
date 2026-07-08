# Replicating this workstation on a new laptop

**Short answer:** the dotfiles reproduce your **configuration** exactly, and the
`Brewfile` now reproduces your **installed packages/apps**. But a handful of
things *cannot* live in a git repo (SSH keys, credentials, identity, app logins)
and macOS **system settings** only transfer if you run `macos/defaults.sh`. Do
the checklist at the bottom and the new machine will match this one.

> ⚠️ **Your new laptop will almost certainly be Apple Silicon (M-series), while
> this one is Intel (x86_64).** That's fine — the shell config is arch-aware
> (Homebrew moves from `/usr/local` to `/opt/homebrew`, handled automatically in
> `zsh/zprofile`). See the "Intel → Apple Silicon" section.

---

## 1. Audit — what `setup.md` listed vs. what is actually installed

Verified on this machine (2026-07-02):

### Installed ✅ (reproduced by dotfiles + Brewfile)
- **CLI:** git, gh, curl, wget, jq, tree, bat, eza, fd, ripgrep, fzf, zoxide,
  starship, lazygit, htop, tmux, neovim, **fastfetch**
- **Version managers:** pyenv (only `system` Python — 3.13 *not* built), fnm
  (node v24.18.0 default + v18.20.8)
- **kubectl** — present, but bundled with **Docker Desktop** (not brew)
- **Casks/apps:** iTerm2, VS Code, Docker Desktop, Postman, DBeaver, Obsidian,
  Slack, Google Chrome, Claude desktop, Spotify, JetBrains Mono (+ Nerd Font)
- **Command Line Tools** (26.6.0)

### From setup.md but **NOT installed** (left as opt-in in the Brewfile)
- **Languages:** Go, Rust, Java/openjdk, Bun ❌
- **Databases:** PostgreSQL, Redis, MySQL ❌ (no `brew services` running)
- **Extra CLI:** yt-dlp, ffmpeg, imagemagick, watch, entr, dust, dua-cli, btop ❌
- **Apps:** OrbStack, Bruno, Raycast, Rectangle, Notion, Discord, Firefox,
  1Password/Bitwarden, Tailscale, Stats, ChatGPT app, Ollama ❌
- **VS Code extensions:** **0 installed** (the `vscode/extensions.txt` list is a
  recommendation, not a capture)

> These are intentionally **not** in the "install" section of the Brewfile —
> they're commented in its `RECOMMENDED (opt-in)` block. Uncomment what you want.

---

## 2. What replicates automatically (via `git clone` + `install.sh` + `brew bundle`)

| Category | Replicated? | Mechanism |
|---|---|---|
| Zsh config (exports, PATH, aliases, functions, completion, prompt, iterm2) | ✅ exact | symlinks from `zsh/` |
| Your custom aliases (flushdns, hidefiles/showfiles, etc.) | ✅ | tracked in `zsh/aliases.zsh` |
| Starship prompt | ✅ | `starship/starship.toml` |
| tmux | ✅ | `tmux/tmux.conf` (plugins need `prefix+I` once) |
| Git config + aliases + global gitignore + commit template | ✅ | `git/` |
| iTerm2 profile, colors, font, shell integration, keybindings | ✅ | dynamic profile + `apply-global-settings.sh` |
| VS Code **settings** | ✅ | `vscode/settings.json` |
| Claude Code conventions | ✅ | `claude/CLAUDE.md` |
| Homebrew formulae **and** GUI apps | ✅ | `Brewfile` (`brew bundle`) |
| macOS system settings | ⚠️ only if you run it | `macos/defaults.sh` |

## 3. What does NOT transfer via the repo (and why)

| Thing | Why | What to do on the new machine |
|---|---|---|
| **SSH private key** | secret — never committed | `security-setup.sh` generates a **new** ed25519 key; add it to GitHub. (Or copy the old key manually if you want the same one.) |
| **Git identity** (name/email) | lives in untracked `~/.gitconfig.local` | recreate it (one command — see checklist) |
| **GitHub CLI / Keychain credentials** | secrets in macOS Keychain | `gh auth login` again |
| **VS Code extensions** | not captured (0 installed now) | install from `vscode/extensions.txt` if wanted |
| **pyenv Python / fnm Node versions** | brew installs the *managers*, not the versions | `pyenv install 3.13`, `fnm install --lts` |
| **App data**: Obsidian vaults, Postman/Bruno collections, DBeaver connections, Raycast config, browser profiles | app-specific stores | sign in / iCloud / manual export-import |
| **App licenses / logins** (Slack, Spotify, 1Password…) | accounts, not files | sign in |
| **macOS account-level**: FileVault, Find My, Touch ID, login items, Time Machine | system/hardware bound | set up manually (setup.md Phase 1) |

---

## 4. Intel → Apple Silicon notes

The new laptop being ARM changes almost nothing for you because the config was
built arch-aware:

- **Homebrew prefix** auto-detected in `zsh/zprofile`: `/opt/homebrew` on ARM,
  `/usr/local` on Intel. No edits needed.
- **PATH / pyenv / fnm** use `$HOME`-relative and `brew --prefix` paths — portable.
- **All formulae/casks** in the Brewfile have native ARM builds.
- **Rosetta 2:** only needed for the rare x86-only app. Install on demand:
  `softwareupdate --install-rosetta --agree-to-license`.
- **Docker/OrbStack:** pull ARM images by default; multi-arch images just work.
  (Consider switching to **OrbStack** on ARM — it's noticeably lighter; it's in
  the Brewfile's opt-in block.)

---

## 5. New-machine checklist (in order)

### 5a. The map — automated vs. manual (tick these off)

On a fresh Mac the entry point is **`bootstrap.sh`** (one `curl` command). It
installs Xcode CLT + Homebrew, clones this repo, then — via two `y/N` prompts —
runs `brew bundle` (all packages) and `security-setup.sh` (SSH key + Keychain),
and in between runs **`install.sh`**, which symlinks every config file, links the
VS Code `code` CLI + settings, links the iTerm2 profile, and seeds
`~/.gitconfig.local`.

So if you run `bootstrap.sh` and answer `y` to both prompts, a good chunk is
already done. Each step below is tagged:
**✅ auto** (bootstrap/install did it) · **◑ finish** (script set it up; you do one last thing) · **○ manual** (all you).
Priority: 🔴 essential · 🟠 stack-dependent · 🟡 optional.

- [ ] **1. ✅ 🔴 Packages** — `brew bundle` runs inside `bootstrap.sh` (answer `y`):
      starship, zsh-autosuggestions/syntax-highlighting, fnm, all CLI + apps.
      *Only manual if you ran `install.sh` alone:* `brew bundle --file ~/dotfiles/Brewfile`.
- [ ] **2. ◑ 🔴 Git identity** — `install.sh` creates `~/.gitconfig.local`, but on a
      fresh Mac with *placeholder* name/email. Edit in your real values (see §5b step 4).
- [ ] **3. ○ 🔴 Node** — `fnm install --lts && fnm default lts-latest`
      (brew installs fnm, the manager — not Node itself).
- [ ] **4. ○ 🔴 corepack** — `corepack enable` (activates pnpm/yarn; needs Node first).
- [ ] **5. ○ 🟠 NestJS CLI** — `pnpm add -g @nestjs/cli` (global; not in any manifest).
- [ ] **6. ○ 🟠 Python** — `pyenv install 3.13 && pyenv global 3.13`.
- [ ] **7. ◑ 🔴 SSH + Keychain** — `security-setup.sh` runs inside `bootstrap.sh`
      (answer `y`): generates the ed25519 key, writes `~/.ssh/config`, moves git
      credentials to Keychain. **You still upload the public key to GitHub**
      (`pbcopy < ~/.ssh/id_ed25519.pub` → GitHub → SSH keys).
- [ ] **8. ○ 🟠 GitHub CLI** — `gh auth login`.
- [ ] **9. ○ 🟡 VS Code extensions** — `install.sh` links the `code` CLI + settings but
      not extensions: `grep -v '^#' ~/dotfiles/vscode/extensions.txt | grep . | xargs -n1 code --install-extension`.
- [ ] **10. ○ 🟡 tmux plugins** — clone TPM to `~/.tmux/plugins/tpm`, then `prefix + I` in tmux.
- [ ] **11. ○ 🟡 macOS defaults** — `bash ~/dotfiles/macos/defaults.sh` (log out/in after).
- [ ] **12. ◑ 🟡 iTerm2 app settings** — `install.sh` links the profile; to make it default
      + apply app prefs, quit iTerm2 and run `bash ~/dotfiles/iterm2/apply-global-settings.sh`.
- [ ] **13. ○ 🔴 Reload shell** — `exec zsh` (or open a new terminal).
- [ ] **14. ○ 🟡 App logins / data** — Slack, Spotify, Obsidian vault, Postman & DBeaver connections.

> **Bottom line:** via `bootstrap.sh`, steps **1** and **7** are automated and
> **2** / **12** are half-done by `install.sh`. The genuinely do-it-yourself steps
> are **3–6, 8–11, 13, 14** — mostly language versions, app logins, and opt-in
> tweaks. Validate anytime with `bash ~/dotfiles/scripts/doctor.sh`.

### 5b. The commands (copy-paste runbook)

```bash
# 1. macOS (manual, setup.md Phase 1): update, FileVault, Find My, Touch ID, strong password.

# 2. Command Line Tools (bootstrap.sh does this, or):
xcode-select --install

# 3. Bootstrap: installs Homebrew, clones dotfiles, links everything.
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Shivanshu-Verma/dotfiles/main/bootstrap.sh)"
#    (bootstrap prompts to run `brew bundle` and security-setup — say yes)

# --- if you didn't use bootstrap, do it manually: ---
# HTTPS clone works before your SSH key exists; switch to SSH after step 5.
git clone https://github.com/Shivanshu-Verma/dotfiles.git ~/dotfiles
cd ~/dotfiles && brew bundle --file Brewfile && ./install.sh

# 4. Git identity (recreates the untracked local file):
cat > ~/.gitconfig.local <<'EOF'
[user]
	name = Shivanshu-Verma
	email = v2.shivanshu@gmail.com
EOF

# 5. SSH key + Keychain, then add the key to GitHub:
bash ~/dotfiles/scripts/security-setup.sh
pbcopy < ~/.ssh/id_ed25519.pub          # paste into GitHub → SSH keys
gh auth login                            # authenticate GitHub CLI

# 6. Language versions (managers came from brew; build the versions):
pyenv install 3.13 && pyenv global 3.13
fnm install --lts && fnm default lts-latest
corepack enable                          # activate pnpm/yarn (bundled with Node)
pnpm add -g @nestjs/cli                   # NestJS CLI (global; not in Brewfile)

# 7. macOS system settings (trackpad, keyboard, Finder, Dock):
bash ~/dotfiles/macos/defaults.sh

# 8. iTerm2: quit it, then set default profile + app prefs:
bash ~/dotfiles/iterm2/apply-global-settings.sh

# 9. VS Code extensions (optional — none are installed today):
grep -v '^#' ~/dotfiles/vscode/extensions.txt | grep -v '^$' \
  | xargs -n1 code --install-extension

# 10. Validate the whole thing:
bash ~/dotfiles/scripts/doctor.sh
```

Then sign into apps (Slack, Spotify, 1Password, etc.) and restore app data
(Obsidian vault, Postman collections, DBeaver connections) from iCloud/export.

---

## 6. Before you hand back the old laptop

```bash
# Make sure nothing is uncommitted, and PUSH the repo. The remote is
# https://github.com/Shivanshu-Verma/dotfiles (public) — keep it in sync.
cd ~/dotfiles && git status && git push

# Keep a capture of anything not in the repo:
brew bundle dump --file ~/dotfiles/Brewfile --force   # re-snapshot packages
code --list-extensions > ~/dotfiles/vscode/extensions.installed.txt  # if you added any
cp ~/.ssh/id_ed25519* /somewhere-safe/    # ONLY if you want the SAME key (else regenerate)
```

> The single most important habit: **keep `~/dotfiles` pushed to GitHub.** The
> remote exists, but a fresh laptop only clones what's been *pushed* — always
> `git push` before you hand back the old machine. Everything else in this doc
> assumes the remote is current.
