# aliases.zsh — curated aliases. Rule: each one must save real keystrokes on a
# frequently used command. No alias-for-the-sake-of-it.
# ---------------------------------------------------------------------------

# --- Listing (eza) --------------------------------------------------------
if command -v eza >/dev/null 2>&1; then
  alias ls='eza --group-directories-first --icons=auto'
  alias ll='eza -la --group-directories-first --icons=auto --git'
  alias la='eza -a  --group-directories-first --icons=auto'
  alias lt='eza --tree --level=2 --icons=auto'
  alias ltt='eza --tree --level=3 --icons=auto'
fi

# --- Viewing (bat) --------------------------------------------------------
if command -v bat >/dev/null 2>&1; then
  alias cat='bat --paging=never'
  alias catp='bat'            # bat with paging when you want it
fi

# --- Navigation -----------------------------------------------------------
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias c='clear'
alias reload='exec zsh'       # reload the shell after config changes
alias path='echo -e "${PATH//:/\n}"'   # print PATH one entry per line

# --- Editor ---------------------------------------------------------------
alias v='nvim'
alias vim='nvim'

# --- Git ------------------------------------------------------------------
alias g='git'
alias gs='git status -sb'
alias gp='git pull'
alias gpf='git push --force-with-lease'   # safe force-push
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gco='git checkout'
alias gsw='git switch'
alias gb='git branch'
alias gd='git diff'
alias gds='git diff --staged'
alias ga='git add'
alias gaa='git add -A'
alias gl='git log --oneline --graph --decorate -20'
alias gla='git log --oneline --graph --decorate --all -30'
command -v lazygit >/dev/null 2>&1 && alias lg='lazygit'

# --- Docker ---------------------------------------------------------------
if command -v docker >/dev/null 2>&1; then
  alias d='docker'
  alias dc='docker compose'
  alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
  alias dpsa='docker ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
  alias dimg='docker images'
  alias dprune='docker system prune -f'
fi

# --- Kubernetes -----------------------------------------------------------
if command -v kubectl >/dev/null 2>&1; then
  alias k='kubectl'
  alias kgp='kubectl get pods'
  alias kgs='kubectl get svc'
  alias kga='kubectl get all'
  alias kgn='kubectl get nodes'
  alias kd='kubectl describe'
  alias kl='kubectl logs -f'
  alias kctx='kubectl config use-context'
  alias kcur='kubectl config current-context'
  alias kns='kubectl config set-context --current --namespace'
fi

# --- Misc -----------------------------------------------------------------
alias myip='curl -s https://ipinfo.io/ip; echo'
alias ports='lsof -iTCP -sTCP:LISTEN -n -P'   # what's listening locally
alias week='date +%V'
alias flushdns="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"
alias hidefiles="defaults write com.apple.finder AppleShowAllFiles YES && killall Finder"
alias showfiles="defaults write com.apple.finder AppleShowAllFiles NO && killall Finder"
