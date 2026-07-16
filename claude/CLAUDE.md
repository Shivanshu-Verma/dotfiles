# Global engineering conventions (for Claude Code)

This file is symlinked to `~/.claude/CLAUDE.md` and applies to every project
unless a project-local `CLAUDE.md` overrides it.

## About this workstation
- Backend engineer. Primary stack: **Node.js / NestJS / TypeScript, PostgreSQL, Docker**. Also work with Python and Go; some Kubernetes. Frontend is secondary.
- macOS (Intel), zsh, Homebrew at `/usr/local`, dotfiles live in `~/dotfiles` (symlinked into `$HOME`).

## Working style
- **Phase non-trivial work.** Present a plan first, then implement in slices, pausing at
  checkpoints. Wait for my literal "proceed" before starting the next phase — don't run ahead.
- **Inspect before you change.** Read the surrounding code — and the repo's `CLAUDE.md` /
  `.claude/` docs, if any — and match its conventions before editing.
- **Minimal diffs ("Ponytail").** Reuse existing services; no single-caller abstractions; don't
  reformat unrelated code. If a large codebase got by without something, don't add it.
- **Verify against the requirement doc.** When work comes from a spec/feature doc, finish with a
  point-by-point walkthrough mapped to the doc, including its open questions.
- **Diagrams are a deliverable.** For non-trivial changes: mermaid flow + sequence diagrams
  (happy AND failure paths), plus a suggested reading order for the changed files.
- **Tests verify state, not just status codes** — e.g. GET after a PATCH to confirm persistence.
  Tests that touch shared/real databases must not leave garbage data.
- **Shared repos stay generic** — no docs/code that hard-reference only my use case.
- **Mock data only** in docs, swagger, examples, fixtures (`John Doe`, `your-api-key`,
  placeholder UUIDs/phone numbers). Never commit secrets. Respect the global gitignore.
- **Outward actions need explicit go-ahead.** Never commit/push/PR/deploy without confirmation —
  I usually commit myself via VS Code. Provide revert guides for temporary/test-only changes.
- **When I say "stop", stop cleanly.** No parting flourishes.
- Explain *why*, not just *what*, in non-trivial changes.
- When unsure between two reasonable approaches, state a recommendation and proceed; don't stall.

## Git & commits
- Branch off `main`; never force-push shared branches (use `--force-with-lease`).
- Conventional Commits: `type(scope): subject`. Keep the subject ≤ 50 chars, imperative mood.
- Confirm before pushing, opening PRs, or any outward-facing action.

## Node / TypeScript / NestJS
- Package manager: **pnpm** (via corepack). Prefer `pnpm` over `npm`/`yarn` in new projects.
- `strict` TypeScript. Prefer explicit return types on exported functions. No `any` without a reason.
- Lint/format with **ESLint + Prettier** (already in VS Code settings). Keep them clean before committing.
- NestJS: follow the module/controller/provider structure; use DI, DTOs with `class-validator`, and `nest generate` for scaffolding.
- Tests with **Jest** (Nest default). Co-locate `*.spec.ts`; test behavior, not implementation.

## Go
- `gofmt`/`goimports` clean. Handle every error explicitly. Small interfaces. Table-driven tests.

## Python
- Target the pyenv-managed version. Use `uv`/`venv` for isolation. Type hints on public functions. `ruff` for lint+format.

## Kubernetes / Docker
- Prefer declarative manifests. Pin image tags (no bare `latest` in prod). Keep contexts explicit.

## Shell / dotfiles
- Shell config is modular under `~/dotfiles/zsh/`. Keep startup fast (<100ms); lazy-init anything slow.
- Any new tool integration goes in the appropriate module, not a monolithic file.
