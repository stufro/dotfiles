# ~/.config/zsh/.zshrc — symlinked to ~/.zshrc by install.sh
#
# Single file for all shell config: zsh reads .zshrc for every interactive
# shell, including the non-login shells tmux spawns. (A .zprofile would be
# skipped inside tmux panes, so everything lives here instead.)
#
# Machine-local secrets and company config go in ~/.zshrc.local, which is
# never committed. See zshrc.local.example.

# Powerlevel10k instant prompt. Must stay near the top: anything above this
# that writes to stdout (or prompts for input) will break it.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

eval "$(/opt/homebrew/bin/brew shellenv)"

# --- oh-my-zsh ---
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git macos bundler asdf zsh-autosuggestions)
source "$ZSH/oh-my-zsh.sh"

# --- PATH ---
# typeset -U keeps entries unique, so re-sourcing this file doesn't duplicate them.
typeset -U path
path=(
  /opt/homebrew/opt/curl/bin
  /opt/homebrew/opt/mariadb@10.6/bin
  "${ASDF_DATA_DIR:-$HOME/.asdf}/shims"
  "$HOME/.local/bin"
  "$HOME/.yarn/bin"
  "$HOME/.config/scripts"
  $path
)

# --- editor ---
export EDITOR=/opt/homebrew/bin/nvim
alias vim=/opt/homebrew/bin/nvim

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Secrets and company-specific config. Not in git.
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
