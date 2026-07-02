# Security model

## What was hardened
1. **Git credentials → macOS Keychain.** The tracked `gitconfig` sets
   `credential.helper = osxkeychain`. Previously the machine used
   `credential.helper = store`, which writes tokens/passwords in **plaintext**
   to `~/.git-credentials`. `security-setup.sh` removes that file (after a
   timestamped backup).

2. **SSH key.** `security-setup.sh` generates an **ed25519** key
   (`~/.ssh/id_ed25519`) — modern, small, fast, and preferred over RSA. The
   machine previously had **no SSH key at all**.

3. **`~/.ssh/config`** enables `AddKeysToAgent` + `UseKeychain`, so the key is
   loaded into the agent and its passphrase (if set) is remembered by the
   Keychain. Permissions are enforced: `700` on `~/.ssh`, `600` on the private
   key and config.

## Identity separation
Personal identity (name/email/signing key) lives in **`~/.gitconfig.local`**,
which is **not tracked** by the repo. This lets you publish your dotfiles
publicly without leaking your email or keys.

## Passphrase note
The generated key has **no passphrase** for a smooth workstation flow. To add
one later (recommended if the laptop leaves your control):
```bash
ssh-keygen -p -f ~/.ssh/id_ed25519          # set a passphrase
ssh-add --apple-use-keychain ~/.ssh/id_ed25519   # cache it in Keychain
```

## Optional next steps (not enabled)
- **Signed commits** (SSH-based): uncomment the `[gpg]/[commit]/[tag]` block in
  `~/.gitconfig.local` and set `user.signingkey = ~/.ssh/id_ed25519.pub`, then
  add the key as a *signing* key on GitHub.
- **`gh auth login`** to authenticate the GitHub CLI.
- **Add the public key to GitHub** (Settings → SSH and GPG keys):
  ```bash
  pbcopy < ~/.ssh/id_ed25519.pub    # then paste on GitHub
  ssh -T git@github.com             # verify
  ```

## Never do
- Don't commit `~/.gitconfig.local`, `~/.git-credentials`, `.env`, or private
  keys. The global gitignore blocks `*.pem`, `*.key`, and `.env*`.
