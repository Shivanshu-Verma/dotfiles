# Recommendations & Future Roadmap

Detailed, actionable follow-ups for this workstation. Nothing here was applied
during the initial build — each item is opt-in, with the rationale, exact
commands, and verification step. Ordered by value/effort.

Context: Intel MacBook Pro 16,1 · macOS 26.5.1 · Homebrew at `/usr/local` ·
zsh · dotfiles at `~/dotfiles`. Primary work: Go, Python/Django, PostgreSQL,
Docker, Kubernetes, DevOps.

---

## Legend
- **Impact:** 🔴 high · 🟠 medium · 🟡 nice-to-have
- **Effort:** ⏱ minutes · ⏳ ~30 min · 📅 ongoing

---

## Part A — Immediate recommendations (do these first)

### A1. Add your SSH key to GitHub — 🔴 ⏱
You generated an ed25519 key during the build but it isn't on GitHub yet, so
`git push` over SSH won't authenticate.

```bash
pbcopy < ~/.ssh/id_ed25519.pub          # copies the PUBLIC key
# GitHub → Settings → SSH and GPG keys → New SSH key → paste → save
ssh -T git@github.com                    # expect: "Hi <user>! You've successfully authenticated"
```
**Why:** SSH auth avoids storing tokens and is the standard for pushing.
**Verify:** the `ssh -T` greeting above.

### A2. Authenticate the GitHub CLI — 🔴 ⏱
`gh` is installed but not logged in. This also configures git to use `gh` as a
credential helper for HTTPS if you choose that path.

```bash
gh auth login          # choose GitHub.com → SSH → use existing ~/.ssh/id_ed25519
gh auth status         # verify
```
**Why:** enables `gh pr`, `gh repo clone`, `gh issue`, and PR review from the terminal.

### A3. Add a passphrase to the SSH key (optional but recommended) — 🟠 ⏱
The key was created without a passphrase for a smooth first run. If the laptop
ever leaves your control, a passphrase (cached in Keychain) is worth it.

```bash
ssh-keygen -p -f ~/.ssh/id_ed25519                 # set a passphrase
ssh-add --apple-use-keychain ~/.ssh/id_ed25519     # remember it in Keychain
```
**Why:** a stolen private key is useless without the passphrase.

### A4. Apply macOS developer defaults — 🟠 ⏱
Fast key-repeat alone is a daily quality-of-life win for terminal/vim users.

```bash
bash ~/dotfiles/macos/defaults.sh
# then log out/in for key-repeat to fully take effect
```
Sets: fast KeyRepeat/InitialKeyRepeat, show hidden files + extensions, list
view, no `.DS_Store` on network/USB, Dock autohide, screenshots → `~/Screenshots`.
**Why:** consistent, reproducible system behavior; the defaults are conservative.
**Reversible:** each `defaults write` can be undone with `defaults delete`.

---

## Part B — Toolchain to install (opt-in Homebrew)

All of these are pre-staged (commented) in [`../Brewfile`](../Brewfile). Uncomment
the lines you want, then:
```bash
brew bundle --file ~/dotfiles/Brewfile      # install everything uncommented
brew bundle check --file ~/dotfiles/Brewfile # see what's missing
```

### B1. Go toolchain — 🔴 ⏳
Go is a stated primary language but isn't installed.

```bash
brew install go
go version
mkdir -p ~/go/bin        # GOPATH already exported by zsh/exports.zsh
```
The starship prompt and `$GOPATH`/`$GOBIN` are already configured to light up
once Go exists. First tools to add:
```bash
go install golang.org/x/tools/gopls@latest              # language server
go install github.com/go-delve/delve/cmd/dlv@latest     # debugger
go install honnef.co/go/tools/cmd/staticcheck@latest    # linter
```
**Verify:** `go version` and `gopls version`.

### B2. Modern Python workflow — 🔴 ⏳
Currently only system Python 3.9.6; pyenv is installed but unused.

```bash
brew install pyenv-virtualenv uv pipx     # uv = fast venv/dep mgr, pipx = isolated CLIs
pipx ensurepath

# Install a current Python and make it the default:
pyenv install 3.13
pyenv global 3.13
python --version                          # should now be 3.13.x via pyenv shims

# Django/backend CLI apps in isolation:
pipx install ruff        # lint + format
pipx install httpie      # human-friendly curl
```
For projects, prefer **uv**:
```bash
uv init myproject && cd myproject
uv add django psycopg[binary]
uv run python manage.py runserver
```
**Why:** `uv` is ~10–100× faster than pip; `pipx` keeps global CLIs from
polluting project envs. pyenv gives per-project Python versions.
**Note:** pyenv is lazy-loaded in `zsh/paths.zsh` — the first `pyenv`/`python`
call triggers full init automatically.

### B3. Kubernetes power tools — 🟠 ⏳
`kubectl` is installed; add navigation + observability.

```bash
brew install kubectx k9s helm stern
```
- `kubectx` / `kubens` — switch context/namespace fast (pairs with the `kctx`/`kns` aliases).
- `k9s` — full-screen cluster TUI (pods, logs, exec, describe).
- `helm` — chart package manager.
- `stern` — tail logs across many pods at once.

The starship prompt already shows `☸ context (namespace)` when a kubeconfig is
active. **Verify:** `k9s version`, `helm version`.

### B4. git-delta for beautiful diffs — 🟠 ⏱
```bash
brew install git-delta
```
Then uncomment the delta block in [`../git/gitconfig`](../git/gitconfig) (the
`core.pager`, `interactive.diffFilter`, and `[delta]` lines are pre-written):
```ini
[core]
    pager = delta
[interactive]
    diffFilter = delta --color-only
[delta]
    navigate = true
    line-numbers = true
    side-by-side = true
```
**Verify:** `git diff` shows syntax-highlighted, side-by-side output.

### B5. direnv for per-project env — 🟡 ⏱
```bash
brew install direnv
echo 'eval "$(direnv hook zsh)"' >> ~/dotfiles/zsh/prompt.zsh   # or a new module
```
Drop a `.envrc` in a project (e.g. `export DATABASE_URL=…`, `layout python`);
direnv loads/unloads it on `cd`. Already git-ignored (`.direnv/`, `.env*`).

### B6. Cloud / IaC CLIs — 🟡 ⏳ (install only what you use)
```bash
brew install awscli terraform          # + cask "google-cloud-sdk" if GCP
```
The starship `aws`/`gcloud` modules are intentionally **disabled** to avoid
prompt noise — re-enable in `starship/starship.toml` if you want them shown.

### B7. GUI apps worth considering — 🟡 ⏱
```bash
brew install --cask raycast rectangle orbstack
```
- **Raycast** — launcher, clipboard history, window management, snippets (replaces Spotlight).
- **Rectangle** — keyboard window snapping (if you don't use Raycast's).
- **OrbStack** — dramatically lighter/faster than Docker Desktop on Intel; drop-in
  Docker + lightweight Linux VMs. Migrating is low-risk (keeps Docker CLI/contexts).

---

## Part C — Editor & AI workflow

### C1. Install the recommended VS Code extensions — 🟠 ⏱
The `code` CLI is now on PATH. Install the curated backend set:
```bash
grep -v '^#' ~/dotfiles/vscode/extensions.txt | grep -v '^$' \
  | xargs -n1 code --install-extension
```
Covers Go, Python+Pylance+Ruff, Docker, Kubernetes, Terraform, YAML, GitLens,
Error Lens, PostgreSQL, REST Client, Remote-SSH/Containers. See
[`../vscode/extensions.txt`](../vscode/extensions.txt).

### C2. Add Claude Code MCP servers — 🟠 ⏳
No MCP servers are configured. Vetted, high-value additions for backend work:
```bash
# Filesystem + git awareness (adjust to available servers):
claude mcp add filesystem -- npx -y @modelcontextprotocol/server-filesystem ~/work
# Inspect what's registered:
claude mcp list
```
Keep the set small and audited. Document any you add in this file.
**Why:** MCP lets Claude read/act on repos and services with explicit scope.

### C3. Neovim starter config — 🟡 ⏳
Neovim 0.12 is installed but has no config (`~/.config/nvim` is empty), so `v`
opens a bare editor.
```bash
# Option A (recommended): kickstart.nvim as a learnable base
git clone https://github.com/nvim-lua/kickstart.nvim ~/.config/nvim
# Option B: track your own under dotfiles/nvim/ and symlink via install.sh
```
Add LSPs for your stack (`gopls`, `pyright`/`ruff`, `yaml-language-server`).
Then commit the config into `~/dotfiles/nvim/` and add a `link` line to
`install.sh` so it's reproducible.

---

## Part D — Repository & reproducibility

### D1. Push dotfiles to GitHub — 🔴 ⏱
The repo is committed locally but has no remote. Publishing makes it your
portable, versioned source of truth (identity/secrets are already isolated in
untracked `~/.gitconfig.local`, so it's safe to make public).
```bash
gh repo create dotfiles --private --source=~/dotfiles --remote=origin --push
# or public:  --public
```
Then update `REPO=` in [`../bootstrap.sh`](../bootstrap.sh) to your URL.
**Verify:** `git -C ~/dotfiles remote -v` and the repo on GitHub.

### D2. Keep the Brewfile authoritative — 🟡 📅
Periodically snapshot and prune your package set:
```bash
brew bundle dump --file ~/dotfiles/Brewfile --force   # capture current state
brew bundle cleanup --file ~/dotfiles/Brewfile        # preview removals of unlisted pkgs
```
Commit changes so a new machine reproduces exactly. Tag milestones:
`git -C ~/dotfiles tag -a v1 -m "baseline"`.

### D3. Run doctor.sh after changes — 🟡 📅
```bash
bash ~/dotfiles/scripts/doctor.sh
```
Fast health-check of symlinks, PATH, prompt, git, SSH, and tool availability.
Extend it as you add tools.

---

## Part E — Security hardening (beyond the baseline)

### E1. SSH-based commit signing — 🟠 ⏳
Get "Verified" badges without GPG. Uncomment the signing block in
`~/.gitconfig.local` and:
```bash
git config --file ~/.gitconfig.local user.signingkey ~/.ssh/id_ed25519.pub
git config --file ~/.gitconfig.local gpg.format ssh
git config --file ~/.gitconfig.local commit.gpgsign true
# Register the SAME key as a "Signing key" on GitHub (separate from auth key).
```
**Verify:** a new commit shows `Verified` on GitHub; locally `git log --show-signature`.

### E2. Separate keys per purpose — 🟡 ⏳
Consider distinct keys for auth vs signing, and per-host `IdentityFile` blocks
in `~/.ssh/config` if you use multiple GitHub/GitLab accounts.

### E3. Enable macOS FileVault (if not already) — 🟠 ⏱
Full-disk encryption protects everything above at rest.
`System Settings → Privacy & Security → FileVault`.

### E4. Audit stored credentials — 🟡 📅
Since credentials now live in Keychain, periodically review with **Keychain
Access.app** and rotate GitHub PATs you no longer use.

---

## Part F — Longer-term roadmap

| # | Item | Impact | Notes |
|---|------|--------|-------|
| F1 | Project scaffolding scripts (`scripts/new-go`, `scripts/new-django`) | 🟠 | Standardize repo layout, Makefile, CI, `.gitignore` |
| F2 | Pre-commit framework | 🟠 | `pipx install pre-commit`; gofmt/ruff/trailing-whitespace hooks per repo |
| F3 | tmux plugin manager + resurrect | 🟡 | `git clone …/tpm ~/.tmux/plugins/tpm` then `prefix + I`; sessions persist reboots |
| F4 | Containerize local Postgres | 🟠 | A `docker-compose.yml` for Postgres/Redis instead of host installs |
| F5 | Dev containers / Remote-SSH | 🟡 | Reproducible per-project toolchains; pairs with VS Code Remote |
| F6 | Dotfiles CI | 🟡 | GitHub Action that runs `install.sh` + `doctor.sh` on a clean macOS runner |
| F7 | Secrets manager | 🟠 | `1password-cli` or `sops`+age for `.env` values instead of plaintext files |
| F8 | Backup strategy | 🟠 | Time Machine + offsite; confirm `~/work` and dotfiles remote are covered |
| F9 | Observability practice | 🟡 | Local Prometheus/Grafana stack via compose for k8s learning |
| F10 | Migrate to OrbStack | 🟡 | Reclaim RAM/CPU vs Docker Desktop on this 16 GB Intel machine |

---

## Suggested sequence

1. **Today:** A1 → A2 (GitHub access) → D1 (push dotfiles) → A4 (macOS defaults).
2. **This week:** B1 (Go) → B2 (Python/uv) → C1 (VS Code extensions) → B4 (delta).
3. **When you start clustering:** B3 (k8s tools) → F4 (compose Postgres).
4. **Ongoing:** E1 (signing), F2 (pre-commit), D2/D3 (keep reproducible).

> Update this file as you complete items — check them off or move them to a
> `## Done` section so the roadmap stays a living document.
