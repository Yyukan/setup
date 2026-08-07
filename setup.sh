#!/usr/bin/env bash
#
# setup.sh — bootstrap a fresh macOS machine with Alex's dev environment
#
# Usage:
#   ./setup.sh                 # interactive: pick sections with y/N prompts
#   ./setup.sh --all           # non-interactive: run every section
#   ./setup.sh --brew --zsh   # run only the listed sections
#   ./setup.sh --help         # show all options
#
# Sections (in dependency order — earlier ones are prerequisites for later ones):
#   00 prereqs     Xcode CLT + Homebrew
#   01 brew        formulae, casks, taps (requires prereqs)
#   02 fonts       Nerd Fonts
#   03 zsh         Oh My Zsh + dotfiles
#   04 tmux        TPM + dotfiles
#   05 vim         vim-plug + symlinked config
#   06 nvim        backup + dotfiles
#   07 java        jenv JDK registration
#   08 iterm2      import color preset
#   09 ghostty     symlink ~/.config/ghostty/config (cmux reads this)
#   10 cmux        symlink cmux.json + verify install
#   11 herdr       standalone brew install
#   12 agents      opencode + pi-coding-agent
#
# All operations are idempotent — safe to re-run after a partial install.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

# ---------- pretty output ----------
if [ -t 1 ]; then
  BOLD=$'\033[1m'; DIM=$'\033[2m'; GREEN=$'\033[32m'; YELLOW=$'\033[33m'
  RED=$'\033[31m'; CYAN=$'\033[36m'; RESET=$'\033[0m'
else
  BOLD=''; DIM=''; GREEN=''; YELLOW=''; RED=''; CYAN=''; RESET=''
fi

info()  { printf '%s==>%s %s\n' "$CYAN"   "$RESET" "$*"; }
ok()    { printf '%s ✓ %s%s\n'      "$GREEN"  "$*" "$RESET"; }
warn()  { printf '%s ! %s%s\n'      "$YELLOW" "$*" "$RESET"; }
err()   { printf '%s ✗ %s%s\n'      "$RED"    "$*" "$RESET" >&2; }
header(){ printf '\n%s%s%s\n'       "$BOLD"   "$*" "$RESET"; printf '%s%s%s\n' "$DIM" "$(printf '%.0s─' $(seq 1 ${#1}))" "$RESET"; }

DRY_RUN=0
RUN_ALL=0
declare -a SELECTED=()

usage() {
  sed -n '2,26p' "$0" | sed 's/^# \{0,1\}//'
  exit 0
}

# ---------- flag parsing ----------
while [ $# -gt 0 ]; do
  case "$1" in
    --all)        RUN_ALL=1 ;;
    --dry-run)    DRY_RUN=1 ;;
    --help|-h)    usage ;;
    --prereqs)    SELECTED+=("prereqs") ;;
    --brew)       SELECTED+=("brew") ;;
    --fonts)      SELECTED+=("fonts") ;;
    --zsh)        SELECTED+=("zsh") ;;
    --tmux)       SELECTED+=("tmux") ;;
    --vim)        SELECTED+=("vim") ;;
    --nvim)       SELECTED+=("nvim") ;;
    --java)       SELECTED+=("java") ;;
    --iterm2)     SELECTED+=("iterm2") ;;
  --ghostty)     SELECTED+=("ghostty") ;;
  --cmux)        SELECTED+=("cmux") ;;
    --herdr)      SELECTED+=("herdr") ;;
    --agents)     SELECTED+=("agents") ;;
    *) err "unknown flag: $1"; usage; exit 1 ;;
  esac
  shift
done

run() {
  if [ "$DRY_RUN" = 1 ]; then
    printf '   %s[dry-run]%s %s\n' "$DIM" "$RESET" "$*"
  else
    eval "$@"
  fi
}

ask() {
  local prompt="$1"
  if [ "$RUN_ALL" = 1 ]; then return 0; fi
  if [ ${#SELECTED[@]} -gt 0 ]; then return 0; fi
  local ans
  read -r -p "$(printf '%s?%s %s [y/N] ' "$YELLOW" "$RESET" "$prompt")" ans
  [[ "$ans" =~ ^[Yy]$ ]]
}

# ---------- sections ----------

section_prereqs() {
  header "00 / prereqs"
  if ! xcode-select -p >/dev/null 2>&1; then
    warn "Xcode Command Line Tools missing"
    if ask "install via 'xcode-select --install'?"; then
      run "xcode-select --install"
      ok "triggered CLT install — re-run setup.sh after it finishes"
    fi
  else
    ok "Xcode CLT present"
  fi
  if ! command -v brew >/dev/null 2>&1; then
    warn "Homebrew missing"
    if ask "install Homebrew?"; then
      run '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
      ok "Homebrew installed"
    fi
  else
    ok "Homebrew present"
  fi
}

section_brew() {
  header "01 / brew"
  if ! command -v brew >/dev/null 2>&1; then err "brew not found — run --prereqs first"; return 1; fi
  info "tapping third-party sources"
  run "brew tap jetbrains/junie"
  run "brew tap umputun/apps"
  run "brew tap yvgude/lean-ctx"
  info "installing core formulae"
  run "brew install zsh-completions zsh-syntax-highlighting fzf tmux midnight-commander coreutils"
  run "brew install yazi ffmpeg-full sevenzip jq poppler fd ripgrep zoxide resvg imagemagick-full font-symbols-only-nerd-font"
  run "brew link ffmpeg-full imagemagick-full -f --overwrite"
  info "installing utilities"
  run "brew install git gh lazygit ifstat telnet htop watch wget httpie tree nmap mactop"
  run "brew install btop ncdu just hunk xcodegen tailscale pipx uv"
  info "installing docker stack"
  run "brew install colima docker docker-compose docker-completion"
  info "installing JDKs and jenv"
  run "brew install jenv openjdk@21 openjdk@25 maven"
  info "installing scala toolchain"
  run "brew install coursier scala scala-cli sbt metals"
  info "installing node"
  run "brew install node"
  info "installing casks and tap packages"
  run "brew install iterm2 maccy cmux herdr opencode opencode-desktop"
  run "brew install jetbrains/junie/junie umputun/apps/revdiff yvgude/lean-ctx/lean-ctx rtk"
  ok "brew stack installed"
  if ask "start colima now (Docker runtime)?"; then
    run "colima start"
  fi
}

section_fonts() {
  header "02 / fonts"
  info "installing Ubuntu Nerd Fonts"
  run "brew install --cask font-ubuntu-nerd-font"
  run "brew install --cask font-ubuntu-mono-nerd-font"
}

section_zsh() {
  header "03 / zsh"
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    if ask "install Oh My Zsh?"; then
      run 'sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended'
      ok "Oh My Zsh installed"
    fi
  else
    ok "Oh My Zsh present"
  fi
  info "linking zshrc"
  [ -f "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ] && run "mv '$HOME/.zshrc' '$HOME/.zshrc.bak'"
  run "ln -sfn '$REPO_DIR/zsh/zshrc' '$HOME/.zshrc'"
}

section_tmux() {
  header "04 / tmux"
  if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    if ask "clone TPM (Tmux Plugin Manager)?"; then
      run "git clone https://github.com/tmux-plugins/tpm '$HOME/.tmux/plugins/tpm'"
    fi
  else
    ok "TPM present"
  fi
  info "linking tmux.conf"
  [ -f "$HOME/.tmux.conf" ] && [ ! -L "$HOME/.tmux.conf" ] && run "mv '$HOME/.tmux.conf' '$HOME/.tmux.conf.bak'"
  run "ln -sfn '$REPO_DIR/tmux/tmux.conf' '$HOME/.tmux.conf'"
  warn "open tmux and press prefix + I to install plugins"
}

section_vim() {
  header "05 / vim"
  if [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
    info "installing vim-plug"
    run "curl -fLo '$HOME/.vim/autoload/plug.vim' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  else
    ok "vim-plug present"
  fi
  run "mkdir -p '$HOME/.vim/plugged' '$HOME/.vim/backup' '$HOME/.vim/swap' '$HOME/.vim/undo' '$HOME/.vim/plugin'"
  info "symlinking vimrc and plugin configs"
  [ -f "$HOME/.vimrc" ] && [ ! -L "$HOME/.vimrc" ] && run "mv '$HOME/.vimrc' '$HOME/.vimrc.bak'"
  run "ln -sfn '$REPO_DIR/vim/vimrc' '$HOME/.vimrc'"
  for f in "$REPO_DIR/vim/plugin/"*.vim; do
    run "ln -sfn '$f' '$HOME/.vim/plugin/$(basename "$f")'"
  done
  if command -v vim >/dev/null 2>&1; then
    info "running :PlugInstall"
    run "vim +PlugInstall +qall"
  else
    warn "vim not on PATH — install via --brew or run :PlugInstall manually"
  fi
}

section_nvim() {
  header "06 / nvim"
  if [ -d "$HOME/.config/nvim" ] && [ ! -L "$HOME/.config/nvim" ]; then
    info "backing up existing nvim config"
    run "mv '$HOME/.config/nvim' '$HOME/.config/nvim.bak'"
  fi
  run "ln -sfn '$REPO_DIR/nvim' '$HOME/.config/nvim'"
  warn "open nvim once to bootstrap lazy.nvim / mason"
}

section_java() {
  header "07 / java"
  if ! command -v jenv >/dev/null 2>&1; then err "jenv not found — run --brew first"; return 1; fi
  info "registering JDKs with jenv"
  for v in 21 25; do
    p="/opt/homebrew/Cellar/openjdk@$v/libexec/openjdk.jdk/Contents/Home"
    [ -d "$p" ] && run "jenv add '$p'" || warn "missing $p — skipping"
  done
  run "jenv global 21"
  run "jenv enable-plugin export"
  run "jenv versions"
}

section_iterm2() {
  header "08 / iterm2"
  if ! [ -f "$REPO_DIR/iterm2/iterm2.json" ]; then
    err "iterm2/iterm2.json missing in repo"
    return 1
  fi
  info "installing iterm2.json as a Dynamic Profile"
  local dst="$HOME/Library/Application Support/iTerm2/DynamicProfiles"
  run "mkdir -p '$dst'"
  [ -f "$dst/setup.json" ] && [ ! -L "$dst/setup.json" ] \
    && run "mv '$dst/setup.json' '$dst/setup.json.bak'"
  run "ln -sfn '$REPO_DIR/iterm2/iterm2.json' '$dst/setup.json'"
  warn "open iTerm2 → Settings → Profiles → select 'Default' (from Dynamic Profiles)"
  warn "then click 'Other Actions… → Set as Default Profile' to activate it"
}

section_ghostty() {
  header "09 / ghostty"
  local cfg_dir="$HOME/.config/ghostty"
  run "mkdir -p '$cfg_dir'"
  [ -f "$cfg_dir/config" ] && [ ! -L "$cfg_dir/config" ] && run "mv '$cfg_dir/config' '$cfg_dir/config.bak'"
  run "ln -sfn '$REPO_DIR/cmux/ghostty.conf' '$cfg_dir/config'"
  if ! command -v ghostty >/dev/null 2>&1; then
    if ask "install standalone Ghostty cask too?"; then
      run "brew install --cask ghostty"
    fi
  else
    ok "ghostty already installed"
  fi
  warn "cmux reads this file for terminal rendering (theme, font, colors)"
}

section_cmux() {
  header "10 / cmux"
  if ! command -v cmux >/dev/null 2>&1; then
    err "cmux not on PATH — run --brew first"
    return 1
  fi
  run "mkdir -p '$HOME/.config/cmux'"
  [ -f "$HOME/.config/cmux/cmux.json" ] && [ ! -L "$HOME/.config/cmux/cmux.json" ] \
    && run "mv '$HOME/.config/cmux/cmux.json' '$HOME/.config/cmux/cmux.json.bak'"
  run "ln -sfn '$REPO_DIR/cmux/cmux.json' '$HOME/.config/cmux/cmux.json'"
  ok "cmux $(cmux --version 2>/dev/null || echo installed)"
}

section_herdr() {
  header "10 / herdr"
  if ! command -v herdr >/dev/null 2>&1; then
    err "herdr not on PATH — run --brew first"
    return 1
  fi
  ok "herdr $(herdr --version 2>/dev/null || echo installed)"
}

section_agents() {
  header "11 / agents"
  if ! command -v opencode >/dev/null 2>&1; then
    warn "opencode not on PATH — run --brew first"
  else
    ok "opencode $(opencode --version 2>/dev/null || echo present)"
  fi
  if command -v npm >/dev/null 2>&1; then
    if ask "install Pi Coding Agent (npm globals)?"; then
      info "installing pi-coding-agent + companions"
      run "npm install -g @mariozechner/pi-coding-agent @fission-ai/openspec @termly-dev/cli"
      run "pi install npm:pi-mcp-adapter"
      run "pi install npm:pi-subagents"
      run "pi install npm:pi-web-access"
      run "pi install npm:pi-powerline-footer"
      run "pi install npm:pi-tool-display"
      run "pi install npm:pi-ask-tool-extension"
      run "pi install https://github.com/umputun/revdiff"
    fi
  else
    warn "npm not on PATH — install Node via --brew first"
  fi
}

# ---------- runner ----------

SECTIONS=(
  "prereqs:section_prereqs"
  "brew:section_brew"
  "fonts:section_fonts"
  "zsh:section_zsh"
  "tmux:section_tmux"
  "vim:section_vim"
  "nvim:section_nvim"
  "java:section_java"
  "iterm2:section_iterm2"
  "ghostty:section_ghostty"
  "cmux:section_cmux"
  "herdr:section_herdr"
  "agents:section_agents"
)

is_selected() {
  local name="$1"
  if [ "$RUN_ALL" = 1 ]; then return 0; fi
  for s in "${SELECTED[@]:-}"; do [ "$s" = "$name" ] && return 0; done
  return 1
}

if [ "$DRY_RUN" = 1 ]; then
  warn "dry-run mode — no changes will be made"
fi

for entry in "${SECTIONS[@]}"; do
  name="${entry%%:*}"
  fn="${entry##*:}"
  if is_selected "$name"; then
    "$fn"
  fi
done

printf '\n%s✓ done%s\n' "$GREEN$BOLD" "$RESET"
