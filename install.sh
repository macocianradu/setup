#!/bin/bash

mkdir projects
cd projects

git clone https://github.com/macocianradu/homefull-api.git
git clone https://github.com/macocianradu/homefull-gui.git
git clone https://github.com/macocianradu/setup.git

git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

cd nvim_config
ln -s .config/nvim ~/.config/nvim
ln -s .vim/undodir ~/.vim/undodir

nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
