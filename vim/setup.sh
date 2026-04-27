#!/bin/sh

set -e

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

# Install vim-plug
if [ ! -f ~/.vim/autoload/plug.vim ]; then
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# Create vim dirs
mkdir -p ~/.vim/plugged ~/.vim/backup ~/.vim/swap ~/.vim/undo ~/.vim/plugin

# Link vimrc and plugins
test -f ~/.vimrc && mv ~/.vimrc ~/.vimrc.bak
ln -sf "$REPO_DIR/vimrc" ~/.vimrc
ln -sf "$REPO_DIR/plugin/"*.vim ~/.vim/plugin/

# Install plugins
vim +PlugInstall +qall
