#!/bin/bash

git clone https://github.com/macocianradu/homefull-api.git
git clone https://github.com/macocianradu/homefull-gui.git
git clone https://github.com/macocianradu/setup.git

git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
    tar xzf nvim-linux64.tar.gz
    /usr/
elif [[ "$OSTYPE" == "darwin"* ]]; then
    curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim-macos-arm64.tar.gz
    tar xzf nvim-macos-arm64.tar.gz
    ./nvim-macos-arm64/bin/nvim
fi

cd nvim_config
ln -s .config/nvim ~/.config/nvim
ln -s .vim/undodir ~/.vim/undodir

nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
