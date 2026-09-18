# dotfiles

Personal config for macOS, checked out at `~/.config`. Public repo — no secrets,
no company-specific config (see [What's deliberately not here](#whats-deliberately-not-here)).

## New machine

```sh
xcode-select --install                      # git, needed for the clone
git clone git@github.com:<user>/config.git ~/.config
~/.config/install.sh
```

`install.sh` is idempotent — re-run it any time. It installs Homebrew and
everything in `Brewfile`, clones oh-my-zsh plus powerlevel10k and
zsh-autosuggestions, symlinks the configs below into `~`, installs tmux plugins
via tpm, and adds the asdf runtimes from `.tool-versions`.

Afterwards:

1. **Remove `~/.zprofile` if one exists.** macOS ships one, and Homebrew's
   installer appends to it. `install.sh` deliberately doesn't touch it, but all
   shell config now lives in `.zshrc` — leaving a `.zprofile` in place means
   login shells source both, duplicating `PATH` entries and re-exporting
   anything in `~/.zshrc.local`. Check what's in it first, move anything worth
   keeping into `~/.zshrc.local`, then delete it:
   ```sh
   cat ~/.zprofile          # anything you still need?
   rm ~/.zprofile
   ```
2. Fill in `~/.zshrc.local` (created from the template by `install.sh`).
3. Open a new shell.
4. Run `nvim` once to let pckr install plugins.

### If you're re-running this on a machine that was set up by hand

`install.sh` moves any real file it needs to replace to `<file>.bak` before
symlinking — so `~/.zshrc`, `~/.p10k.zsh`, `~/.tool-versions`, `~/.ansible.cfg`,
and the two `~/.claude/` files become `.bak` copies. Those are your only record
of the originals, and they will differ from the repo versions. Diff them before
deleting. (`*.bak` is gitignored, since `~/.zshrc.bak` may contain credentials.)

## Layout

| Path | Linked to | What |
|---|---|---|
| `zsh/.zshrc` | `~/.zshrc` | all shell config — one file, see note below |
| `zsh/.p10k.zsh` | `~/.p10k.zsh` | powerlevel10k prompt |
| `zsh/zshrc.local.example` | — | template for the untracked local/secrets file |
| `.tmux.conf` | `~/.tmux.conf` | tmux + tpm plugin list |
| `nvim/` | — | read from `~/.config/nvim` directly |
| `htop/`, `gtk-2.0/`, `git/ignore` | — | read from `~/.config` directly |
| `claude/CLAUDE.md` | `~/.claude/CLAUDE.md` | Claude Code preferences |
| `claude/settings.json` | `~/.claude/settings.json` | Claude Code settings |
| `.tool-versions` | `~/.tool-versions` | asdf runtime versions |
| `.ansible.cfg` | `~/.ansible.cfg` | ansible python interpreter |
| `scripts/` | on `PATH` | helper scripts |
| `Brewfile` | — | `brew bundle` package list |

### Why one `.zshrc` and no `.zprofile`

zsh reads `.zprofile` only for *login* shells. tmux spawns non-login interactive
shells, so anything defined in `.zprofile` is missing inside tmux panes unless it
happens to be inherited from the shell that started the server. Keeping
everything in `.zshrc` — which every interactive shell reads — avoids that whole
class of problem.

## Neovim LSP

Uses Neovim's built-in LSP client (`vim.lsp.config` / `vim.lsp.enable`) with
`blink.cmp` for completion. Servers are declared directly in `nvim/init.lua` --
Neovim ships the API but no server definitions, so there's no `nvim-lspconfig`.

`ruby-lsp` must be installed **once per asdf Ruby version**, because it loads a
project's own gems to index them and so has to run under the Ruby that project
pins. `install.sh` does this for every installed version; after adding a new
Ruby:

```sh
ASDF_RUBY_VERSION=<version> gem install ruby-lsp && asdf reshim ruby
```

Symptom of a missing one: `ruby_lsp` exits with code 126 and the log shows
"No version is set for command ruby-lsp". Check with `:checkhealth vim.lsp`.

Treesitter is pinned to the `master` branch: the default `main` is the
in-progress rewrite, which drops `.setup()` and the textobjects integration.
Run `:TSUpdate` once on a new machine to compile the parsers.

`conform.nvim` owns format-on-save for all filetypes. Ruby has no entry, so it
falls through to `ruby-lsp` and the project's own RuboCop; other filetypes use
prettier/gofmt/stylua/shfmt when present. `:Format` runs it manually and
`:FormatToggle` suspends it for the current buffer.

## Git config

Generic settings live in `git/config`, which git reads natively from
`~/.config/git/config` -- no symlink needed. Identity and the `gh` credential
helpers stay in untracked `~/.gitconfig`; git merges both.

`rerere` is the one worth knowing about: with `pull.rebase = true`, long-lived
branches hit the same conflicts repeatedly, and it replays your resolution.

## What's deliberately not here

This repo is public, so these stay local and need recreating by hand:

- **`~/.zshrc.local`** — credentials and work-specific env vars. Start from
  `zsh/zshrc.local.example`, then `chmod 600` it. Rotate any credentials when
  setting up a new machine.
- **`~/.gitconfig`** — identity and the `gh` credential helper:
  ```sh
  git config --global user.name  "..."
  git config --global user.email "..."
  git config --global pull.rebase true
  git config --global push.autoSetupRemote true
  git config --global --add credential."https://github.com".helper \
    '!/opt/homebrew/bin/gh auth git-credential'
  gh auth login
  ```
- **`~/.ssh/`** — keys and `config`. Copy out-of-band (the host config references
  internal infrastructure). Note it `Include`s `~/.colima/ssh_config`, which
  colima generates.
- **iTerm2** — settings live in `~/Library/Application Support/iTerm2`, symlinked
  here as `iterm2/AppSupport`. Import `Tmux iTerm Profile.json` as a profile, and
  `iTerm2 State Settings.itermexport` for window state.

## Regenerating the Brewfile

The Brewfile lists **top-level packages only** (`brew leaves`) — dependencies
are left out because brew resolves them at install time, which keeps the file
readable and lets `brew autoremove` clean up orphans.

```sh
brew bundle dump --force --file=Brewfile
```

`dump` emits the full dependency closure and a description comment per package,
so afterwards: drop any `brew` entry that isn't in `brew leaves`, delete the
description comments, and re-apply the header notes.

Note `brew bundle check` reports outdated packages as "unsatisfied", so it can
fail even when everything is installed. `brew outdated` tells you which.
