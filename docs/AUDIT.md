# Phase 1 — Workstation Audit

**Host:** NTILs-MacBook-Pro · **User:** shivanshuverma · **Date:** 2026-07-02
**Method:** read-only inspection. Nothing was modified.

---

## 1. Hardware & OS

| Item | Value |
|---|---|
| Model | MacBook Pro 16,1 (2019) |
| CPU | **Intel Core i7-9750H** @ 2.60GHz — 6 cores / 12 threads |
| Architecture | **x86_64** (Intel, *not* Apple Silicon) |
| RAM | 16 GB |
| macOS | 26.5.1 (build 25F80) |
| Storage | 2.0 TB volume, ~1.9 TB free (Data volume 32 GB used) |
| Rosetta | not applicable (Intel) |

> **Key implication:** Intel Mac → Homebrew prefix is correctly `/usr/local` (not `/opt/homebrew`). All install scripts must be arch-aware. Some newer casks are Apple-Silicon-only; we stay on x86_64-safe tooling.

---

## 2. Homebrew

- **Version:** 6.0.6, prefix `/usr/local`, stable branch, updated 2 days ago.
- **CLT:** Command Line Tools present (26.6.0). Xcode.app not installed (fine for backend work).
- **Taps:** none (uses new API-based core — normal for brew 6.x).
- **Formulae (leaves):** `bat curl eza fd fnm fzf gh git htop jq lazygit neovim pyenv ripgrep starship tmux tree wget zoxide`
- **Casks:** `font-jetbrains-mono` `font-jetbrains-mono-nerd-font` `iterm2` `obsidian` `postman` `spotify`
- **Outdated:** `libevent`, `tmux` (minor).

**Gaps:** no `go`, `rust`/`rustup`, `helm`, `k9s`, `kubectx`, `awscli`, `terraform`, `pipx`, `uv`, `gnupg`, `git-delta`, `dust`, `duf`, `httpie`, `direnv`, `tmux plugin manager`.

---

## 3. Shell

- **Login shell:** `/bin/zsh` (zsh 5.9). Good — no migration needed.
- **Startup time:** ~0.03s (excellent; keep it that way).
- **`.zshrc` (293 bytes):** monolithic-but-tiny. Sets `PATH`, fnm init, and 9 aliases. No completion caching, no fzf/zoxide/starship init, no history tuning.
- **`.zprofile` (44 bytes):** `brew shellenv` only.
- **No** `.zshenv`, `.aliases`, `.exports`, `.functions`, `.paths`, oh-my-zsh, or `~/.config/starship.toml`.

**Current aliases:** `ll` (eza -la), `gs gp gc` (git), `v` (nvim), `c` (clear), `..` `...`.

**Not wired up despite being installed:** `starship`, `zoxide`, `fzf`, `bat`, most of `eza`. These tools are present but the shell doesn't initialize them.

---

## 4. Git & GitHub

| Item | State | Note |
|---|---|---|
| git | 2.55.0 | current |
| user.name | `Shivanshu-Verma` | |
| user.email | `v2.shivanshu@gmail.com` | ⚠️ differs from Claude account email `gap.workplace@gmail.com` — confirm which is canonical |
| credential.helper | **`store`** | 🔴 **plaintext credentials on disk** — should be `osxkeychain` |
| commit signing | none | no SSH/GPG signing configured |
| core.excludesfile | unset | no global gitignore |
| gh CLI | 2.95.0 | **not logged in** |
| defaults | none | no `pull.ff`, `fetch.prune`, `init.defaultBranch`, `push.autoSetupRemote`, diff tooling |

---

## 5. Security posture

- 🔴 **No SSH keys.** `~/.ssh` contains only an `agent/` dir — no keypair, no `config`.
- 🔴 **`credential.helper=store`** writes GitHub tokens/passwords in plaintext to `~/.git-credentials`.
- ⚪ **No GPG** installed → no signed commits.
- SSH agent running but has no identities.

---

## 6. Containers & Kubernetes

- **Docker:** CLI 29.6.1, Docker Desktop installed. Contexts: `default` and `desktop-linux` (current). Daemon not running at audit time. No OrbStack.
- **kubectl:** v1.36.1 (bundled kustomize v5.8.1). **No kubeconfig / zero contexts.**
- **Missing:** `helm`, `k9s`, `kubectx`/`kubens`, `kind`, `minikube`, `stern`.

---

## 7. Cloud / IaC

None installed: no `terraform`, `awscli`, `az`, `gcloud`, `pulumi`, `ansible`.

---

## 8. Language toolchains

| Lang | State |
|---|---|
| **Python** | system `python3` 3.9.6 only. `pyenv` 2.7.3 installed but global = `system` (no versions built). `pip3` present; **no `pipx`, `uv`, `poetry`**. `PYENV_ROOT` unset in env. |
| **Go** | 🔴 **not installed** (despite being a primary language). |
| **Node** | via **fnm** 1.39.0 → node v24.18.0 (default). No pnpm/yarn/bun. |
| **Rust** | not installed. |
| **Java** | no JDK. |

---

## 9. Editors & AI tooling

- **VS Code:** app installed, but **`code` CLI not on PATH** and **0 extensions installed**. No user `settings.json`.
- **Neovim:** 0.12.3 installed, **no config** (`~/.config/nvim` absent).
- **Claude Code:** v2.1.197 at `~/.local/bin/claude`. `settings.json` = `{"theme":"dark"}` only. **No MCP servers.** No global `~/.claude/CLAUDE.md`. `backups/`, `projects/` present.
- **Copilot:** `~/.copilot/ide` present (GitHub Copilot CLI/IDE artifacts).
- **Cursor / Windsurf / Zed / Ollama:** none.

---

## 10. Terminal, fonts, GUI apps

- **iTerm2** installed; config dir symlinks to `~/Library/Application Support/iTerm2`. No exported prefs plist under version control.
- **Fonts:** full **JetBrains Mono** + **JetBrains Mono Nerd Font** family installed. ✅ Ready for a Nerd-Font prompt.
- **tmux:** installed, **no `~/.tmux.conf`**, no TPM.
- **starship:** installed, **no config** (using defaults).
- **GUI apps present:** iTerm2, VS Code, DBeaver, Postman, Obsidian, Slack, Spotify.
- **No** Raycast, Rectangle, Alfred, or window manager.

---

## 11. macOS defaults (sampled)

| Setting | Value |
|---|---|
| KeyRepeat / InitialKeyRepeat | **unset** (slow default repeat) |
| Finder ShowPathbar | on ✅ |
| AppleShowAllExtensions | on ✅ |
| Finder AppleShowAllFiles | off |
| Dock autohide | off |

---

## 12. Developer folders

- `~/work` exists but **empty**. `~/Work` (capital) also present/empty.
- No `~/dev`, `~/Developer`, `~/code`, `~/projects`, `~/src`, `~/go`.
- Home has 22 dotfiles/dirs; a `.DS_Store` is present in `$HOME`.

---

## 13. Summary of findings

**Strengths:** modern CLI tools already installed (eza/bat/fd/rg/fzf/zoxide/lazygit), Nerd Font ready, zsh login shell, blazing-fast startup, huge free disk, current Homebrew.

**High-value gaps (ranked):**
1. 🔴 **Security:** no SSH key, plaintext git credentials, no signing.
2. 🟠 **Shell not leveraging installed tools** (starship/zoxide/fzf/bat not initialized).
3. 🟠 **Go missing** — a stated primary language.
4. 🟠 **Python workflow immature** — no pipx/uv, pyenv unused.
5. 🟠 **No config for tmux / starship / neovim** despite tools installed.
6. 🟡 **k8s/cloud tooling absent** (helm, k9s, kubectx; cloud CLIs).
7. 🟡 **VS Code:** no CLI, no extensions, no settings.
8. 🟡 **No dotfiles repo** → nothing reproducible or versioned.
9. 🟡 **Claude Code:** no MCP servers, no global memory/instructions.
