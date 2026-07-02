# Phase 2 — Design Document

Design of an elite, reproducible backend/cloud-native workstation for an **Intel** MacBook Pro.
Nothing is implemented in this phase. Every decision below has a stated rationale.

---

## Guiding principles

1. **Modular over monolithic** — `.zshrc` sources small, single-purpose files. Easy to reason about and diff.
2. **Reproducible** — one `Brewfile` + `install.sh` rebuilds the machine from zero, idempotently.
3. **Fast** — keep shell startup < 100ms; lazy-init anything slow; cache completions.
4. **Secure by default** — SSH `ed25519`, credentials in Keychain, optional signing.
5. **Documented** — every file, alias, function, and package explained.
6. **Non-destructive** — timestamped backups before touching any existing file.
7. **Arch-aware** — everything assumes `/usr/local` (Intel) but detects prefix so it also works on Apple Silicon later.

---

## 1. Repository structure

```
~/dotfiles/                     # git repo, symlinked into $HOME
├── README.md                   # overview + quickstart
├── install.sh                  # idempotent orchestrator (symlinks + brew + tools)
├── bootstrap.sh                # brand-new-Mac entry (installs brew, clones, runs install.sh)
├── Brewfile                    # declarative package list
├── macos/
│   └── defaults.sh             # opt-in macOS system tweaks
├── zsh/
│   ├── zshrc                   # loader only — sources modules
│   ├── zprofile                # login: brew shellenv, PATH
│   ├── exports.zsh             # env vars (EDITOR, LANG, tool config)
│   ├── paths.zsh               # single source of truth for PATH
│   ├── aliases.zsh             # aliases
│   ├── functions.zsh           # shell functions
│   ├── completion.zsh          # compinit + fzf/tools completion (cached)
│   └── prompt.zsh              # starship + zoxide + fzf init
├── git/
│   ├── gitconfig               # includes a local, untracked identity file
│   ├── gitconfig.local.example # user.name/email/signing (git-ignored real copy)
│   ├── gitignore_global
│   └── gitmessage              # commit template
├── tmux/
│   └── tmux.conf
├── starship/
│   └── starship.toml
├── nvim/                       # minimal starter (kickstart-style) — optional
├── vscode/
│   ├── settings.json
│   └── extensions.txt          # installed via `code --install-extension`
├── claude/
│   └── CLAUDE.md               # global engineering conventions
├── scripts/
│   ├── backup.sh               # timestamped backup helper
│   └── doctor.sh               # post-install validation
└── docs/
    ├── AUDIT.md                # Phase 1 report
    ├── DESIGN.md               # this file
    ├── ALIASES.md              # cheat-sheet
    └── SECURITY.md
```

**Why symlinks (not copies):** editing a tracked file updates `$HOME` live; `git status` shows drift. **Why `gitconfig.local`:** keeps personal email/signing keys out of a repo you may push publicly.

---

## 2. Shell architecture

- `zprofile` (login shells): `brew shellenv`, then source `paths.zsh`. Runs once per login.
- `zshrc` (interactive): sources `exports → paths → aliases → functions → completion → prompt`. No logic of its own beyond the loop.
- **PATH strategy:** built exactly once in `paths.zsh` in priority order:
  `~/.local/bin` → homebrew → pyenv shims → go/bin → cargo/bin → system. Guard against duplicates with a `path_prepend` helper. fnm/pyenv init lives here (lazy where possible).
- **History:** 50k lines, shared, `HIST_IGNORE_DUPS`, `HIST_IGNORE_SPACE`, `INC_APPEND_HISTORY`.
- **Completion:** `compinit -C` with a daily-rebuilt dump cache to keep startup fast.

---

## 3. Prompt (starship) — minimal, backend-focused

Enabled modules only: **directory, git_branch, git_status, golang, python, nodejs, docker_context, kubernetes (+ namespace), cmd_duration (>2s), character (red on error)**. Everything else disabled. Two-line prompt so long paths/contexts never crowd the input line. Nerd Font glyphs (already installed).

---

## 4. Aliases & functions (curated, not bloated)

**Keep/extend existing:** `ll`, `gs`, `gp`, `gc`, `v`, `c`, `..`, `...`.
**Add high-value only:**
- Navigation/listing: `ls`→eza, `la`, `lt` (tree), `cat`→bat (paged off).
- Git: `gco`, `gd`, `gl` (pretty log), `gb`, `lg` (lazygit), `gpf` (push --force-with-lease).
- Docker: `d`, `dc` (compose), `dps`, `dprune`.
- k8s: `k`=kubectl, `kx` (context), `kn` (namespace), `kgp`, `kl` (logs), plus completion.
- Misc: `reload` (exec zsh), `path` (print PATH lines), `weather`, `myip`.

**Functions:** `mkcd`, `extract` (any archive), `gclone` (clone + cd), `killport <n>`, `dsh <container>` (shell into), `serve` (python http.server), `backup <file>`.

Rule: an alias must save real keystrokes on a frequent command, or it doesn't ship.

---

## 5. Git workflow

`init.defaultBranch=main`, `pull.ff=only`, `fetch.prune=true`, `push.autoSetupRemote=true`, `push.default=current`, `rebase.autostash=true`, `diff.colorMoved=zebra`, `merge.conflictstyle=zdiff3`. **`credential.helper=osxkeychain`** (replaces plaintext `store`). Editor `nvim`. Optional **git-delta** as pager. Global gitignore covers `.DS_Store`, `.env`, `__pycache__`, `node_modules`, `*.log`, IDE dirs, Go/Python build artifacts. Commit template with a conventional-commits hint. Signing (SSH-based) offered as opt-in.

---

## 6. Container / Kubernetes / Cloud workflow

- Docker: alias layer + `docker context` awareness in prompt. Keep Docker Desktop (OrbStack optional, lighter — flagged as recommendation).
- k8s: install `kubectx`/`kubens`, `k9s`, `helm`, `stern`; kube context+namespace in prompt; `k` completion.
- Cloud: install **only what you use** — default to none, offer `awscli`/`terraform`/`gcloud` as opt-in to avoid bloat.

---

## 7. Language workflows

- **Go:** install via brew; `GOPATH=~/go`, `~/go/bin` on PATH; version in prompt.
- **Python:** `pyenv` for versions (install a current 3.12/3.13), **`pipx`** for CLI apps, **`uv`** for fast project/venv management. Django/backend friendly.
- **Node:** keep **fnm** (already good); add corepack for pnpm/yarn on demand.
- **Rust:** offer `rustup` as opt-in (secondary).

---

## 8. tmux

Prefix `C-a`, mouse on, vi copy-mode, 50k scrollback, clipboard via `pbcopy`, intuitive splits (`|`/`-`), `prefix r` reload, base-index 1. **TPM** + `tmux-sensible`, `tmux-resurrect`, `tmux-continuum` (session persistence). Status bar shows session, git, and k8s/host context, styled to match starship.

---

## 9. Claude Code workflow

- Global `~/.claude/CLAUDE.md` with your engineering conventions (Go/Python/k8s style, commit format, "inspect before change").
- Shell helpers: `cc` (launch), quick project bootstrap.
- MCP: recommend a small, vetted set (e.g. filesystem, git) — **opt-in**, documented in `docs/`.
- PATH already correct (`~/.local/bin`).

---

## 10. Security strategy

1. Generate **`ed25519`** SSH key (`~/.ssh/id_ed25519`) + `~/.ssh/config` with `UseKeychain`, `AddKeysToAgent`.
2. Migrate git credentials **plaintext → osxkeychain**; remove `~/.git-credentials`.
3. Optional GPG or SSH commit signing.
4. `gh auth login` to establish authenticated GitHub access.
5. Correct file perms (`700` `~/.ssh`, `600` keys).

---

## 11. Backup, versioning, validation

- **Backup:** `scripts/backup.sh` copies any file it's about to replace to `~/.dotfiles-backups/<timestamp>/`.
- **Versioning:** the dotfiles repo *is* the version history; `Brewfile` pins the package set; `git tag` milestones.
- **Validation:** `scripts/doctor.sh` opens a fresh shell and asserts: aliases resolve, PATH sane, starship/zoxide/fzf active, tmux config loads, git config correct, docker/kubectl/claude on PATH. Run after install.

---

## 12. What we will NOT do

- No oh-my-zsh (adds startup cost; we stay lean).
- No mass alias dumps.
- No changing your git identity or installing cloud CLIs without explicit confirmation.
- No destructive macOS defaults; system tweaks are opt-in via `macos/defaults.sh`.
