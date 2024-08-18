#!/bin/bash

echo "----- Cloning homefull-api -----"
if [ -d "$HOME/projects/homefull-api" ]; then
    echo "[Skipped] homefull-api already exists"
else
    git clone https://github.com/macocianradu/homefull-api.git\
        ~/projects/homefull-api
fi

echo "----- Cloning homefull-gui -----"
if [ -d "$HOME/projects/homefull-gui" ]; then
    echo "[Skipped] homefull-gui already exists"
else
    git clone https://github.com/macocianradu/homefull-gui.git\
        ~/projects/homefull-gui
fi

echo "----- Cloning packer -----"
if [ -d "$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim" ]; then
    echo "[Skipped] Packer already exists"
else
    git clone --depth 1 https://github.com/wbthomason/packer.nvim\
        ~/.local/share/nvim/site/pack/packer/start/packer.nvim
fi

echo "----- Downloading NVIM -----"
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
    tar xzf nvim-linux64.tar.gz
    usr/
elif [[ "$OSTYPE" == "darwin"* ]]; then
    if [ -d "$HOME/Applications/nvim" ]; then
        echo "[Skipped] NVIM already installed"
    else
        curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim-macos-arm64.tar.gz
        tar xzf nvim-macos-arm64.tar.gz
        mv nvim-macos-arm64 ~/Applications/nvim/
    fi
fi

sudo nvim --headless nvim ~/projects/setup/.config/nvim/lua/wicked/packer.lua\
    -c 'autocmd User PackerComplete quitall' -c 'so' -c 'PackerSync'

echo "----- Copying NVIM configuration -----"
if [ ! -d "$HOME/.config" ]; then
    echo ".config folder not found. Creating one"
    mkdir ~/.config
fi
ln -s ~/projects/setup/.config/nvim ~/.config/nvim
if [ ! -d "$HOME/.vim" ]; then
    echo ".vim folder not found. Creating one"
    mkdir ~/.vim
fi
ln -s ~/projects/setup/.vim/undodir ~/.vim/undodir
