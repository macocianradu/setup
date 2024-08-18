#!/bin/bash

git clone https://github.com/macocianradu/homefull-api.git\
    ~/projects/homefull-api
git clone https://github.com/macocianradu/homefull-gui.git\
    ~/projects/homefull-gui

git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
    tar xzf nvim-linux64.tar.gz
    /usr/
elif [[ "$OSTYPE" == "darwin"* ]]; then
    curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim-macos-arm64.tar.gz
    mkdir ~/Applications/nvim
    tar xzf nvim-macos-arm64.tar.gz
    mv nvim-macos-arm64.tar.gz ~/Applications/nvim/
fi

ln -s ~/projects/setup/.config/nvim ~/.config/nvim
ln -s ~/projects/setup/.vim/undodir ~/.vim/undodir

nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
