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

# --- fzf ---
# Ctrl-R fuzzy history, Ctrl-T file picker, Alt-C cd. `fzf --zsh` emits both
# the keybindings and the completions, replacing the older shell/*.zsh sources.
if command -v fzf >/dev/null 2>&1; then
  source <(fzf --zsh)

  # fd respects .gitignore and skips .git, unlike find.
  if command -v fd >/dev/null 2>&1; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
  fi

  export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --info=inline'
  # Show full multi-line commands when searching history.
  export FZF_CTRL_R_OPTS='--preview "echo {}" --preview-window=down:3:hidden:wrap --bind "?:toggle-preview"'
fi

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Secrets and company-specific config. Not in git.
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
