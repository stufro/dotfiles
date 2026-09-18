#!/usr/bin/env bash
# Bootstrap a new machine from this repo. Safe to re-run: every step checks
# before it acts.
#
#   git clone <this repo> ~/.config && ~/.config/install.sh
#
# Deliberately does NOT manage: ~/.gitconfig, ~/.ssh/* (keys and the host
# config hold company infrastructure), or ~/.zshrc.local (secrets). See README.

set -euo pipefail

CONFIG_DIR="${CONFIG_DIR:-$HOME/.config}"
ZSH_CUSTOM_DIR="$HOME/.oh-my-zsh/custom"

info() { printf '\033[0;34m==>\033[0m %s\n' "$1"; }
skip() { printf '    \033[0;32m✓\033[0m %s\n' "$1"; }
warn() { printf '\033[0;33m!!\033[0m %s\n' "$1"; }

# Symlink $2 -> $1, backing up an existing real file first.
link() {
  local src=$1 dest=$2
  if [[ -L $dest ]]; then
    # An existing link may be relative (e.g. a hand-made .config/.tmux.conf)
    # while we always write absolute ones, so compare what they resolve to.
    # Uses cd/pwd rather than `readlink -f`, which stock macOS readlink lacks
    # and coreutils may not be installed yet on a first run.
    local cur
    cur=$(readlink "$dest")
    [[ $cur != /* ]] && cur="$(cd "$(dirname "$dest")" && cd "$(dirname "$cur")" && pwd)/$(basename "$cur")"
    if [[ $cur == "$src" ]]; then
      skip "$dest already linked"
      return
    fi
    rm "$dest"
  elif [[ -e $dest ]]; then
    warn "$dest exists as a real file; moving to $dest.bak"
    mv "$dest" "$dest.bak"
  fi
  ln -s "$src" "$dest"
  info "linked $dest -> $src"
}

# Clone $1 to $2 if not already there.
clone() {
  local url=$1 dest=$2
  if [[ -d "$dest/.git" ]]; then
    skip "$(basename "$dest") already cloned"
  else
    info "cloning $(basename "$dest")"
    git clone --depth=1 "$url" "$dest"
  fi
}

# --- 1. homebrew + packages ---
if ! command -v brew >/dev/null 2>&1; then
  info "installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  skip "Homebrew present"
fi

info "brew bundle (this takes a while)"
brew bundle install --file="$CONFIG_DIR/Brewfile"

# --- 2. oh-my-zsh ---
if [[ -d "$HOME/.oh-my-zsh" ]]; then
  skip "oh-my-zsh present"
else
  info "installing oh-my-zsh"
  # --keep-zshrc: we supply our own, and --unattended stops it launching a shell.
  RUNZSH=no KEEP_ZSHRC=yes sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
    "" --unattended --keep-zshrc
fi

# --- 3. zsh theme + plugins (git clones, not brew) ---
clone https://github.com/romkatv/powerlevel10k.git      "$ZSH_CUSTOM_DIR/themes/powerlevel10k"
clone https://github.com/zsh-users/zsh-autosuggestions   "$ZSH_CUSTOM_DIR/plugins/zsh-autosuggestions"

# --- 4. symlinks ---
link "$CONFIG_DIR/zsh/.zshrc"   "$HOME/.zshrc"
link "$CONFIG_DIR/zsh/.p10k.zsh" "$HOME/.p10k.zsh"
link "$CONFIG_DIR/.tmux.conf"   "$HOME/.tmux.conf"
link "$CONFIG_DIR/.tool-versions" "$HOME/.tool-versions"
link "$CONFIG_DIR/.ansible.cfg" "$HOME/.ansible.cfg"

# Claude Code reads ~/.claude directly, so link the individual files and leave
# the rest of that directory (sessions, history, caches) alone.
mkdir -p "$HOME/.claude"
link "$CONFIG_DIR/claude/CLAUDE.md"     "$HOME/.claude/CLAUDE.md"
link "$CONFIG_DIR/claude/settings.json" "$HOME/.claude/settings.json"

# --- 5. tmux plugins ---
clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
if [[ -x "$HOME/.tmux/plugins/tpm/bin/install_plugins" ]]; then
  info "installing tmux plugins"
  "$HOME/.tmux/plugins/tpm/bin/install_plugins"
fi

# --- 6. asdf runtimes ---
if command -v asdf >/dev/null 2>&1; then
  for plugin in ruby nodejs golang rust yarn; do
    if asdf plugin list 2>/dev/null | grep -qx "$plugin"; then
      skip "asdf plugin $plugin"
    else
      info "asdf plugin add $plugin"
      asdf plugin add "$plugin"
    fi
  done
  info "asdf install (from .tool-versions)"
  (cd "$HOME" && asdf install)
else
  warn "asdf not on PATH; skipping runtimes. Re-run this script from a new shell."
fi

# --- 7. machine-local secrets ---
if [[ -f "$HOME/.zshrc.local" ]]; then
  skip "~/.zshrc.local present"
else
  cp "$CONFIG_DIR/zsh/zshrc.local.example" "$HOME/.zshrc.local"
  chmod 600 "$HOME/.zshrc.local"
  warn "Created ~/.zshrc.local from template — add secrets/work env vars before use."
fi

cat <<'DONE'

Done. Remaining manual steps (deliberately not automated):

  1. Remove ~/.zprofile if present — all shell config is in .zshrc now; keeping
     both means login shells source both. Check it first, then `rm ~/.zprofile`.
  2. Fill in ~/.zshrc.local       — credentials + work env vars, not in this repo
  3. Recreate ~/.gitconfig        — user.name/email, pull.rebase, gh credential helper
  4. Recreate ~/.ssh/config + keys — copy out-of-band, never via this repo
  5. iTerm2: import the profile   — see README
  6. Open a new shell, then run `nvim` to let pckr install plugins

DONE
