# Global engineering conventions (for Claude Code)

This file is symlinked to `~/.claude/CLAUDE.md` and applies to every project
unless a project-local `CLAUDE.md` overrides it.

## About this workstation
- Backend / cloud-native engineer. Primary stacks: **Go, Python (Django), PostgreSQL, Docker, Kubernetes**. Frontend is secondary.
- macOS (Intel), zsh, Homebrew at `/usr/local`, dotfiles live in `~/dotfiles` (symlinked into `$HOME`).

## Working style
- **Inspect before you change.** Read the surrounding code and match its conventions before editing.
- Prefer small, reviewable diffs. Don't reformat unrelated code.
- Explain *why*, not just *what*, in non-trivial changes.
- Never commit secrets. Respect the global gitignore.
- When unsure between two reasonable approaches, state a recommendation and proceed; don't stall.

## Git & commits
- Branch off `main`; never force-push shared branches (use `--force-with-lease`).
- Conventional Commits: `type(scope): subject`. Keep the subject ≤ 50 chars, imperative mood.
- Confirm before pushing, opening PRs, or any outward-facing action.

## Go
- `gofmt`/`goimports` clean. Handle every error explicitly. Small interfaces. Table-driven tests.

## Python
- Target the pyenv-managed version. Use `uv`/`venv` for isolation. Type hints on public functions. `ruff` for lint+format.

## Kubernetes / Docker
- Prefer declarative manifests. Pin image tags (no bare `latest` in prod). Keep contexts explicit.

## Shell / dotfiles
- Shell config is modular under `~/dotfiles/zsh/`. Keep startup fast (<100ms); lazy-init anything slow.
- Any new tool integration goes in the appropriate module, not a monolithic file.
