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

echo "----- Downloading NVIM -----"
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    nvim_path="/opt/nvim-linux64"
    echo "----- Found Linux-GNU system -----"
    echo "Downloading nvim"
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
    sudo rm -rf /opt/nvim
    echo "Copying NVIM to /opt/nvim-linux64"
    sudo tar -C /opt -xzf nvim-linux64.tar.gz
    echo "Adding NVIM to PATH in ./bashrc"
    echo "export PATH="\$PATH:$nvim_path/bin"" >> ~/.bashrc
    echo "NVIM added to path, run '. ~/.bashrc' to reload PATH variable"

elif [[ "$OSTYPE" == "darwin"* ]]; then
    nvim_path=~/Applications/nvim
    if [ -d "$HOME/Applications/nvim" ]; then
        echo "[Skipped] NVIM already installed"
    else
        curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim-macos-arm64.tar.gz
        tar xzf nvim-macos-arm64.tar.gz
        mv nvim-macos-arm64 $nvim_path
    fi
fi

# sudo $nvim_path/bin/nvim --headless ~/projects/setup/.config/nvim/lua/wicked/packer.lua\
#    -c 'autocmd User PackerComplete quitall' -c 'so' -c 'PackerSync'

echo "----- Copying NVIM configuration -----"
if [ ! -d "$HOME/.config" ]; then
    echo ".config folder not found. Creating one"
    mkdir ~/.config
fi
ln -s ~/projects/setup/.config/nvim ~/.config/
if [ ! -d "$HOME/.vim" ]; then
    echo ".vim folder not found. Creating one"
    mkdir ~/.vim
fi
ln -s ~/projects/setup/.vim/undodir ~/.vim/
