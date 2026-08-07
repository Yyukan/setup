# Environment Setup

Dotfiles and bootstrap script for Alex's macOS dev environment.

## Quick start (fresh machine)

```sh
git clone git@github.com:yyukan/setup.git ~/setup
cd ~/setup
./setup.sh --all        # non-interactive: run every section
# or, for a guided run with y/N prompts:
./setup.sh
```

`setup.sh` is idempotent and runs the sections in dependency order. Each section can also be invoked on its own:

```sh
./setup.sh --prereqs --brew --fonts --zsh --tmux --vim --nvim --java --iterm2 --ghostty --cmux --herdr --agents
./setup.sh --brew          # just the brew stack
./setup.sh --zsh --nvim    # just the dotfiles
./setup.sh --dry-run --all # preview without making changes
```

## Sections (run order)

| #  | Section    | What it does                                           | Manual step after |
|----|------------|--------------------------------------------------------|-------------------|
| 00 | prereqs    | Xcode CLT + Homebrew                                   | finish CLT popup  |
| 01 | brew       | formulae, casks, taps                                  | `colima start`    |
| 02 | fonts      | Ubuntu Nerd Fonts                                      | —                 |
| 03 | zsh        | Oh My Zsh + symlinked `~/.zshrc`                       | `chsh -s zsh`     |
| 04 | tmux       | TPM + symlinked `~/.tmux.conf`                         | `prefix + I`      |
| 05 | vim        | vim-plug + symlinked vimrc/plugin                      | —                 |
| 06 | nvim       | symlinked `~/.config/nvim`                             | open nvim once    |
| 07 | java       | jenv registers JDK 17 / 21 / 25                        | —                 |
| 08 | iterm2     | symlinks iTerm2 Dynamic Profile                        | set as default in UI |
| 09 | ghostty    | symlinks `~/.config/ghostty/config` (cmux reads this)   | —                 |
| 10 | cmux       | verify install + config dir                            | launch cmux once  |
| 11 | herdr      | verify install                                         | —                 |
| 12 | agents     | opencode + pi-coding-agent (optional)                  | —                 |

## Layout

```
setup/
├── setup.sh                 # main bootstrap (this README's source of truth)
├── README.md                # you are here
├── zsh/zshrc                # -> ~/.zshrc
├── tmux/tmux.conf           # -> ~/.tmux.conf
├── vim/
│   ├── vimrc                # -> ~/.vimrc
│   ├── plugin/*.vim         # -> ~/.vim/plugin/
│   └── vim-shortcuts.md     # keybinding cheatsheet
├── nvim/                    # -> ~/.config/nvim
│   ├── init.lua
│   └── lua/{core,plugins}/
├── iterm2/iterm2.json       # iTerm2 Dynamic Profile (Solarized Dark, manual import)
├── cmux/ghostty.conf        # -> ~/.config/ghostty/config (read by cmux)
└── .gitignore
```

## Per-section notes

### Brew

The `setup.sh --brew` block installs everything: core utils, dev tooling (java/scala/node), docker stack (colima), CLI agents (opencode/herdr/junie/revdiff/lean-ctx/rtk), and casks (iterm2/maccy/cmux).

It also adds the taps needed by `junie`, `revdiff`, and `lean-ctx`:

```sh
brew tap jetbrains/junie
brew tap umputun/apps
brew tap yvgude/lean-ctx
```

After the brew run, start the Docker runtime once:

```sh
colima start
```

### Zsh

Oh My Zsh is installed unattended; existing `~/.zshrc` is backed up to `~/.zshrc.bak` before being replaced by a symlink into this repo. After the run:

```sh
chsh -s $(which zsh)    # switch default shell; log out and back in
```

### Tmux

TPM is cloned into `~/.tmux/plugins/tpm` and `~/.tmux.conf` becomes a symlink. Open a tmux session and press `prefix + I` (default `Ctrl-b I`) to install plugins.

### Vim

vim-plug, then symlinks for vimrc and the four plugin configs in `vim/plugin/`. `:PlugInstall` runs automatically. See `vim/vim-shortcuts.md` for the keymaps.

### Neovim

`~/.config/nvim` is replaced with a symlink to `nvim/`. Old config is backed up to `~/.config/nvim.bak`. Open nvim once to bootstrap the plugin manager.

### Java

`openjdk@21` and `openjdk@25` are installed via brew and registered with jenv. Default is 21.

```sh
jenv versions            # confirm 21 / 25 are registered
```

If you later add a JDK with a different Cellar path, re-run with `--java`.

### iTerm2

The file `iterm2/iterm2.json` is an iTerm2 **Dynamic Profile** (named "Default") that sets the Solarized Dark color scheme, the UbuntuMono Nerd Font Mono font, mouse reporting, 60 rows, etc. The script symlinks it to:

```
~/Library/Application Support/iTerm2/DynamicProfiles/setup.json
```

Then in iTerm2: **Settings → Profiles → Default** (which appears under the "Dynamic Profiles" header) → **Other Actions… → Set as Default Profile**.

### Ghostty (cmux config)

cmux uses [libghostty](https://github.com/ghostty-org/ghostty) for terminal rendering and reads your **Ghostty config** for theme, font, colors, and cursor. The file `cmux/ghostty.conf` in this repo is symlinked to `~/.config/ghostty/config` — that's the source of truth for cmux's terminal appearance.

The symlink works even if you don't install standalone Ghostty. If you also want the Ghostty terminal app, `setup.sh --ghostty` will offer to install the cask.

### cmux

cmux is installed as a cask and its config dir is created. `cmux/cmux.json` (a JSONC template shipped by cmux) is symlinked to `~/.config/cmux/cmux.json` so edits stay tracked.

### Herdr

Verifies the `herdr` binary. No config to link (herdr reads its own state on demand).

### Agents

`opencode` comes from brew. Pi Coding Agent is pulled via `npm install -g` along with its companion packages; `pi install` then adds MCP adapters and the revdiff plugin.

## Color scheme

[Solarized Dark](https://ethanschoonover.com/solarized/) across iTerm2 and Vim. The Vim colorscheme is provided by the `altercation/vim-colors-solarized` vim-plug bundle; the airline theme is set to `solarized` in `vim/vimrc`.

## Fonts

[Ubuntu Nerd Font](https://www.nerdfonts.com/font-downloads) — installed by `setup.sh --fonts` via brew cask (`font-ubuntu-nerd-font` and `font-ubuntu-mono-nerd-font`).
