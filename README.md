# dotfiles

A modular, reproducible macOS development environment for **backend engineering**
(Node.js / NestJS / TypeScript, PostgreSQL, Docker — plus Python & Go).

Built for an Intel MacBook Pro (Homebrew at `/usr/local`), but arch-aware so it
also works on Apple Silicon.

## Highlights
- **Modular zsh** — `.zshrc` is a loader; real config lives in small files under `zsh/`.
- **Fast** — cached completions, lazy version-manager init; startup stays well under 100 ms.
- **Minimal starship prompt** — directory, git, Go/Python/Node, docker & k8s context, exec time.
- **Hardened git + SSH** — Keychain credentials, ed25519 key, sane defaults.
- **Reproducible** — one command (`bootstrap.sh`) rebuilds from zero; `install.sh` re-links config idempotently.
- **Documented** — every file, alias, and decision explained in `docs/`.

## Setup

> 📖 **Replicating on a new laptop?** Read **[docs/REPLICATION.md](docs/REPLICATION.md)**
> first — it's the complete, in-order guide (with a tickable "automated vs. manual"
> checklist in §5a and an Intel → Apple Silicon section). The steps below are the
> condensed version.

Pick **one** path. Both leave you with the same working environment; the manual
follow-up is identical (and small). Everything is non-destructive — existing
files are backed up before anything is symlinked.

### ▸ Path A — Fresh Mac (recommended): `bootstrap.sh`

One command does everything: installs Xcode Command Line Tools + Homebrew, clones
this repo to `~/dotfiles`, and runs `install.sh` for you.

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Shivanshu-Verma/dotfiles/main/bootstrap.sh)"
```

It asks **two yes/no questions** — answer `y` to both:
1. **“Install Homebrew packages from Brewfile now?”** → installs every CLI + app.
2. **“Run security setup (SSH key + Keychain)?”** → generates your ed25519 key.

Then do **step 3 (Finish setup)** below.

### ▸ Path B — Existing Mac (Homebrew already installed): `install.sh`

Use this if you already have Homebrew and just want the config on a machine.

```bash
git clone https://github.com/Shivanshu-Verma/dotfiles.git ~/dotfiles
cd ~/dotfiles
brew bundle --file Brewfile            # install all packages (Path A prompts this for you)
./install.sh                           # symlink all config (backs up originals)
bash scripts/security-setup.sh         # SSH key + Keychain (one-time)
```

Then do **step 3 (Finish setup)** below.

### ▸ Step 3 — Finish setup (both paths)

A few things can’t be scripted (language versions install on demand; keys and
logins are personal). Run these, then reload:

```bash
# Git identity — install.sh seeds ~/.gitconfig.local with PLACEHOLDERS; set yours:
printf '[user]\n\tname = Your Name\n\temail = you@example.com\n' > ~/.gitconfig.local

fnm install --lts && fnm default lts-latest    # Node (brew installs fnm, not Node)
corepack enable                                # activate pnpm / yarn
pyenv install 3.13 && pyenv global 3.13        # Python (skip if unused)
pnpm add -g @nestjs/cli                        # NestJS CLI (skip if unused; no `pnpm setup` needed — PNPM_HOME is preconfigured)

pbcopy < ~/.ssh/id_ed25519.pub                 # then paste into GitHub → SSH keys
gh auth login                                  # authenticate the GitHub CLI

exec zsh                                        # reload the shell
bash scripts/doctor.sh                          # validate everything
```

> **Full checklist** (VS Code extensions, tmux plugins, macOS defaults, iTerm2, app
> logins) with an “automated vs. manual” map: **[docs/REPLICATION.md §5a](docs/REPLICATION.md)**.

## Layout
```
install.sh              idempotent symlinker (backs up originals first)
bootstrap.sh            zero-to-working on a new Mac
Brewfile                declarative package manifest (opt-in installs)
zsh/                    zshrc, zprofile, exports, paths, aliases, node, functions,
                        completion, prompt, iterm2, plugins  (each single-purpose)
git/                    gitconfig, gitignore_global, gitmessage, local example
tmux/                   tmux.conf (TPM, resurrect, vi copy, mouse)
starship/               starship.toml (minimal backend prompt)
vscode/                 settings.json + recommended extensions.txt
claude/                 CLAUDE.md global engineering conventions
macos/                  defaults.sh (opt-in system tweaks)
scripts/                backup.sh, doctor.sh, security-setup.sh
docs/                   REPLICATION, ROADMAP, ALIASES, SECURITY, ITERM2, AUDIT, DESIGN
```

## Everyday use
- `reload` — restart the shell after editing config.
- `bash scripts/doctor.sh` — health-check the environment.
- Edit a tracked file (e.g. `zsh/aliases.zsh`); the symlink means it's live immediately.
- Personal identity lives in `~/.gitconfig.local` (untracked). Never commit secrets.

## Docs
- [docs/REPLICATION.md](docs/REPLICATION.md) — **rebuild this setup on a new laptop** (Intel→Apple Silicon safe)
- [docs/ROADMAP.md](docs/ROADMAP.md) — detailed recommendations & future work
- [docs/ALIASES.md](docs/ALIASES.md) — alias/function cheat-sheet
- [docs/SECURITY.md](docs/SECURITY.md) — security model
- [docs/ITERM2.md](docs/ITERM2.md) — terminal setup
- [docs/AUDIT.md](docs/AUDIT.md) · [docs/DESIGN.md](docs/DESIGN.md) — original audit & design
