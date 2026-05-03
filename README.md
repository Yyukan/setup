# Environment Setup

## Table of Contents

- [Brew](#brew)
- [ZSh](#zsh)
- [Color Scheme](#color-scheme)
- [Fonts](#fonts)
- [Vim](#vim)
- [Tmux](#tmux)
- [iTerm2](#iterm2)
- [Java](#java)
- [Agents](#agents)

## Brew

Install Homebrew:
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

```shell
# ZSh, terminal & core utils
brew install zsh-completions zsh-syntax-highlighting fzf tmux midnight-commander coreutils
brew install yazi ffmpeg-full sevenzip jq poppler fd ripgrep zoxide resvg imagemagick-full font-symbols-only-nerd-font
brew link ffmpeg-full imagemagick-full -f --overwrite

# Other utils
brew install git gh lazygit ifstat telnet htop watch wget httpie fd ripgrep tree nmap mactop

# Docker
brew install colima docker docker-compose docker-completion

# Java
brew install jenv openjdk@17 openjdk@21 openjdk@25 maven

# Scala
brew install coursier scala scala-cli sbt metals

# Node.js
brew install node
```

## ZSh

Install Oh My Zsh:
```
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

Copy [`zsh/zshrc`](zsh/zshrc) to `~/.zshrc`

## Color Scheme

Using [Solarized Dark](https://ethanschoonover.com/solarized/) across iTerm2 and Vim.

**iTerm2:** download the color preset and import it:
```
curl -O https://raw.githubusercontent.com/altercation/solarized/master/iterm2-colors-solarized/Solarized%20Dark.itermcolors
```
Then: `Profiles -> Colors -> Color Presets... -> Import... -> Solarized Dark`

**Vim:** included via [vim-yyukan](https://github.com/Yyukan/vim-yyukan) plugin (see Vim section).

## Fonts

Install [Ubuntu Nerd Mono](https://www.nerdfonts.com/font-downloads) via brew:
```
brew install --cask font-ubuntu-nerd-font
brew install --cask font-ubuntu-mono-nerd-font
```

## Vim

Config lives in [`vim/`](vim/) — vimrc + plugin configs.

Uses [vim-plug](https://github.com/junegunn/vim-plug). Run the setup script:
```
./vim/setup.sh
```

This will:
- Install vim-plug
- Symlink `vimrc` → `~/.vimrc` and plugin configs → `~/.vim/plugin/`
- Run `:PlugInstall`

Plugins: `vim-airline`, `vim-fugitive`, `nerdtree`, `ctrlp`, `solarized`

## Tmux

Install TPM (plugin manager):
```
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Copy [`tmux/tmux.conf`](tmux/tmux.conf) to `~/.tmux.conf`, then install plugins:
```
tmux new -s main
# inside tmux: press prefix + I  (default prefix is Ctrl+b)
```

## iTerm2

```
brew install --cask iterm2 maccy
```

```
Profiles -> Colors -> Color presets... -> Solorized Dark
Foreground - 70% gray
Background - 10% gray

Profiles -> Colors -> Brighten bold text (Uncheck)
Profiles -> Text -> Font -> UbuntuMono Nerd Font Mono -> Regular - 16
Profiles -> Text -> Text Rendering -> Draw bold text in bright colors (Check)
Profiles -> PROFILE -> Command > Send text at start
tmux ls && read tmux_session && tmux attach -t ${tmux_session:-default} || tmux new -s ${tmux_session:-default}
```

## Java

Register installed JDKs with jenv and set default:
```
jenv add /opt/homebrew/Cellar/openjdk@17/libexec/openjdk.jdk/Contents/Home
jenv add /opt/homebrew/Cellar/openjdk@21/libexec/openjdk.jdk/Contents/Home
jenv add /opt/homebrew/Cellar/openjdk@25/libexec/openjdk.jdk/Contents/Home
jenv global 21

jenv versions
jenv enable-plugin export
```

## Agents

**Claude Code:**
```
brew install --cask claude-code
```

**Copilot CLI:**
```
brew install --cask copilot-cli
```

**Gemini CLI:**
```
brew install gemini-cli
```

**OpenCode:**
```
brew install opencode
brew install --cask opencode-desktop
```

**Pi Coding Agent:**
```
npm install -g @mariozechner/pi-coding-agent \
  @fission-ai/openspec \
  @termly-dev/cli \

pi install npm:pi-mcp-adapter
pi install npm:pi-subagents
pi install npm:pi-web-access
pi install npm:pi-powerline-footer
pi install npm:pi-tool-display
pi install npm:pi-ask-tool-extension
pi install https://github.com/umputun/revdiff
```
