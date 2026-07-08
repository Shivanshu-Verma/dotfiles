#!/usr/bin/env bash
#
# clone-bitbucket.sh — Clone (or update) every repo in a Bitbucket Cloud workspace.
#
# Auth: Atlassian API token via HTTP Basic (email:token).
#       Create one at https://id.atlassian.com/manage-profile/security/api-tokens
# Clone: over SSH (assumes your public key is registered in Bitbucket).
#
# Usage:
#   ./clone-bitbucket.sh <API_TOKEN> [ATLASSIAN_EMAIL]
#
#   API_TOKEN         (required)  your Atlassian API token
#   ATLASSIAN_EMAIL   (optional)  defaults to $BITBUCKET_EMAIL or the value below
#
# Examples:
#   ./clone-bitbucket.sh "$MY_TOKEN"
#   ./clone-bitbucket.sh "$MY_TOKEN" me@company.com
#
# Re-runnable: existing repos are fetched (--prune), missing ones are cloned.

set -euo pipefail

# ---- config -----------------------------------------------------------------
WORKSPACE="quicksellcoreteam"
DEST_DIR="${HOME}/Projects/Work"
DEFAULT_EMAIL="shivanshu.verma@doubletick.io"   # override with arg 2 or $BITBUCKET_EMAIL
PARALLEL="${PARALLEL:-4}"                 # concurrent clones/fetches
SKIP_ARCHIVED="${SKIP_ARCHIVED:-1}"       # 1 = skip archived repos
API="https://api.bitbucket.org/2.0"
# -----------------------------------------------------------------------------

TOKEN="${1:-}"
EMAIL="${2:-${BITBUCKET_EMAIL:-$DEFAULT_EMAIL}}"

die() { echo "error: $*" >&2; exit 1; }

[ -n "$TOKEN" ] || die "missing API token. Usage: $0 <API_TOKEN> [ATLASSIAN_EMAIL]"
for c in curl jq git; do command -v "$c" >/dev/null || die "'$c' not found in PATH"; done

mkdir -p "$DEST_DIR"

echo ">> Workspace : $WORKSPACE"
echo ">> Auth as   : $EMAIL"
echo ">> Target    : $DEST_DIR"
echo ">> Parallel  : $PARALLEL"
echo

# GET a URL with Basic auth. Prints response body to stdout.
# On HTTP >= 400, prints status + body to stderr and returns 1.
api_get() {
  local url="$1" body code
  # Append the HTTP status on its own trailing line, then split it off.
  body="$(curl -sS -u "${EMAIL}:${TOKEN}" -w $'\n%{http_code}' "$url")" \
    || { echo "curl transport error for $url" >&2; return 1; }
  code="${body##*$'\n'}"
  body="${body%$'\n'*}"
  if [ "$code" -ge 400 ]; then
    echo "HTTP $code from $url" >&2
    echo "$body" | jq . 2>/dev/null >&2 || echo "$body" >&2
    return 1
  fi
  printf '%s' "$body"
}

# Verify the credentials before doing any work; gives a precise error.
# Hit the repositories endpoint itself (pagelen=1) so we only require the
# same scope the real work needs — read:repository:bitbucket.
preflight() {
  echo ">> Verifying credentials..."
  if ! api_get "${API}/repositories/${WORKSPACE}?pagelen=1&fields=size" >/dev/null; then
    cat >&2 <<EOF

Authentication/authorization failed (401/403). Checklist:
  * Use an Atlassian API TOKEN with Bitbucket scopes — NOT your password, and
    NOT a legacy app password (app passwords stopped working June 9, 2026).
    Create one: Atlassian account > Security > 'Create and manage API tokens'
    > 'Create API token with scopes' > app: Bitbucket > scope:
    read:repository:bitbucket (add write:repository:bitbucket only if pushing).
  * arg 1 must be the API token; the auth username is your Atlassian account
    email (you passed: $EMAIL) — never a username or the token name.
  * That email must be listed under Email Aliases on your Bitbucket
    Personal settings page, or Basic auth returns 401.
EOF
    exit 1
  fi
}

# Fetch all pages of repositories. We only ask for the fields we need.
# Prints lines of: "<slug>\t<ssh_clone_url>"
list_repos() {
  local url="${API}/repositories/${WORKSPACE}?pagelen=100&fields=next,values.slug,values.links.clone"
  while [ -n "$url" ] && [ "$url" != "null" ]; do
    local resp
    resp="$(api_get "$url")" || die "failed to list repositories"

    echo "$resp" | jq -r '
      .values[]
      | [ .slug,
          ( .links.clone[] | select(.name == "ssh") | .href )
        ] | @tsv'

    url="$(echo "$resp" | jq -r '.next // ""')"
  done
}

# Clone only if absent. Existing directories are left completely untouched
# (never fetched) so local/uncommitted changes are safe.
sync_repo() {
  local slug="$1" ssh_url="$2"
  local path="${DEST_DIR}/${slug}"
  if [ -e "$path" ]; then
    echo "  skipped  $slug (already exists)"
    return 0
  fi
  if git clone --quiet "$ssh_url" "$path"; then
    echo "  cloned   $slug"
  else
    echo "  FAILED   $slug (clone)" >&2
    return 1
  fi
}
# Don't hang on an unknown host key when cloning many repos non-interactively.
export GIT_SSH_COMMAND="${GIT_SSH_COMMAND:-ssh -o StrictHostKeyChecking=accept-new}"

preflight

REPO_LIST="$(mktemp)"
FAIL_LOG="$(mktemp)"
trap 'rm -f "$REPO_LIST" "$FAIL_LOG"' EXIT

echo ">> Listing repositories..."
list_repos > "$REPO_LIST"
COUNT="$(grep -c . "$REPO_LIST" || true)"
[ "$COUNT" -gt 0 ] || die "no repositories returned (no access, or empty workspace?)"
echo ">> Found $COUNT repositories. Syncing into $DEST_DIR"
echo

# Parallelism via native background jobs (reliable tab-splitting, Bash 3.2 safe).
# Throttle to $PARALLEL concurrent jobs by polling the running-job count.
while IFS=$'\t' read -r slug url; do
  [ -n "$slug" ] || continue
  if [ -z "$url" ]; then
    echo "  SKIPPED  $slug (no ssh clone url)" >&2
    echo "$slug" >> "$FAIL_LOG"
    continue
  fi
  ( sync_repo "$slug" "$url" || echo "$slug" >> "$FAIL_LOG" ) &
  while [ "$(jobs -r | wc -l | tr -d ' ')" -ge "$PARALLEL" ]; do
    sleep 0.2
  done
done < "$REPO_LIST"
wait

echo
FAILS="$(wc -l < "$FAIL_LOG" | tr -d ' ')"
if [ "$FAILS" -gt 0 ]; then
  echo ">> Done with $FAILS failure(s):" >&2
  sed 's/^/   - /' "$FAIL_LOG" >&2
  exit 1
fi
echo ">> All $COUNT repositories synced successfully into $DEST_DIR"

