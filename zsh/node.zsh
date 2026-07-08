# node.zsh — Node.js / NestJS backend workflow aliases.
# Each block is guarded so aliases only exist when the tool is installed.
# Node itself is managed by fnm (see paths.zsh); pnpm/yarn come via corepack.
# ---------------------------------------------------------------------------

# --- npm ------------------------------------------------------------------
if command -v npm >/dev/null 2>&1; then
  alias ni='npm install'
  alias nid='npm install --save-dev'
  alias nig='npm install -g'
  alias nr='npm run'
  alias nrd='npm run dev'
  alias nrb='npm run build'
  alias nrs='npm run start'
  alias nrt='npm test'
  alias nx='npx'
fi

# --- pnpm (preferred; provided by corepack) -------------------------------
if command -v pnpm >/dev/null 2>&1; then
  alias p='pnpm'
  alias pi='pnpm install'
  alias pa='pnpm add'
  alias pad='pnpm add -D'
  alias prm='pnpm remove'
  alias pr='pnpm run'
  alias prd='pnpm run dev'
  alias prb='pnpm run build'
  alias prs='pnpm run start'
  alias pt='pnpm test'
  alias px='pnpm dlx'          # run a package without installing (like npx)
fi

# --- yarn (via corepack) --------------------------------------------------
if command -v yarn >/dev/null 2>&1; then
  alias y='yarn'
  alias ya='yarn add'
  alias yad='yarn add -D'
  alias yr='yarn run'
fi

# --- NestJS CLI -----------------------------------------------------------
# Install once per machine: `pnpm add -g @nestjs/cli` (or `npm i -g @nestjs/cli`).
if command -v nest >/dev/null 2>&1; then
  alias ns='nest start'
  alias nsw='nest start --watch'          # dev: hot reload
  alias nsdbg='nest start --debug --watch'
  alias nsb='nest build'
  alias nsg='nest generate'               # e.g. `nsg module users`, `nsg resource cats`
fi
