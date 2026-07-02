# dotfiles

A modular, reproducible macOS development environment for **backend / cloud-native
engineering** (Go, Python/Django, PostgreSQL, Docker, Kubernetes).

Built for an Intel MacBook Pro (Homebrew at `/usr/local`), but arch-aware so it
also works on Apple Silicon.

## Highlights
- **Modular zsh** — `.zshrc` is a loader; real config lives in small files under `zsh/`.
- **Fast** — cached completions, lazy version-manager init; startup stays well under 100 ms.
- **Minimal starship prompt** — directory, git, Go/Python/Node, docker & k8s context, exec time.
- **Hardened git + SSH** — Keychain credentials, ed25519 key, sane defaults.
- **Reproducible** — one `Brewfile` + `install.sh` rebuild the machine idempotently.
- **Documented** — every file, alias, and decision explained in `docs/`.

## Quickstart (existing machine)
```bash
git clone https://github.com/Shivanshu-Verma/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh                          # symlinks config, backs up originals
bash scripts/security-setup.sh        # SSH key + Keychain (one-time)
exec zsh                              # reload
bash scripts/doctor.sh                # validate
```

## Fresh machine
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Shivanshu-Verma/dotfiles/main/bootstrap.sh)"
```
`bootstrap.sh` installs CLT + Homebrew, clones this repo, and runs `install.sh`.

## Layout
```
install.sh              idempotent symlinker (backs up originals first)
bootstrap.sh            zero-to-working on a new Mac
Brewfile                declarative package manifest (opt-in installs)
zsh/                    zshrc, zprofile, exports, paths, aliases, functions,
                        completion, prompt  (each single-purpose)
git/                    gitconfig, gitignore_global, gitmessage, local example
tmux/                   tmux.conf (TPM, resurrect, vi copy, mouse)
starship/               starship.toml (minimal backend prompt)
vscode/                 settings.json + recommended extensions.txt
claude/                 CLAUDE.md global engineering conventions
macos/                  defaults.sh (opt-in system tweaks)
scripts/                backup.sh, doctor.sh, security-setup.sh
docs/                   AUDIT, DESIGN, ALIASES, SECURITY
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
