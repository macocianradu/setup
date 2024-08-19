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

if [[ "$OSTYPE" == "linux"* ]]; then
    echo "----- Linux-Gnu detected -----"
    nvim_path="/opt/nvim-linux64"
    echo "----- Downloading NVIM -----"
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
    sudo rm -rf /opt/nvim
    echo "Copying NVIM to /opt/nvim-linux64"
    sudo tar -C /opt -xzf nvim-linux64.tar.gz
    echo "Adding NVIM to PATH in ./bashrc"
    echo "export PATH="\$PATH:$nvim_path/bin"" >> ~/.bashrc
    echo "NVIM added to path, run '. ~/.bashrc' to reload PATH variable"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "----- OSX detected -----"
    nvim_path="~/Applications/nvim"
    if [ -d "$HOME/Applications/nvim" ]; then
        echo "[Skipped] NVIM already installed"
    else
        echo "----- Downloading nvim -----"
        curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim-macos-arm64.tar.gz
        tar xzf nvim-macos-arm64.tar.gz
        mv nvim-macos-arm64 $nvim_path
    fi
elif [[ "$OSTYPE" == "msys"* ]]; then
    echo "----- Windows detected -----"
    if [ "$env:Path" == "*Neovim*" ]; then
        echo "[Skipped NVIM already installed"
    else
        echo "----- Downloading nvim -----"
        curl -o nvim-win64.msi https://github.com/neovim/neovim/releases/latest/download/nvim-win64.msi
        ./nvim-win64.msi "/passive"
    fi
fi

if [[ ! -d "$HOME/.local/share/nvim/roslyn" ]] then
    echo "----- Roslyn LS not detected: Downloading now -----"
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        ls_url="https://zaxvsblobprodwus215.vsblob.vsassets.io/b-63b6279ad2f14bc3a21cdb7614e92831/5787C047B250801723E628CEF9CA582F82C848FE406E4553BA02BF5ECA870EBD00.blob?sv=2019-07-07&sr=b&si=1&sig=L9sr005TS6IonkYAeB7KYh7kW9CnWNr9MAqNu4ypEUo%3D&spr=https&se=2024-08-19T00%3A25%3A13Z&rscl=x-e2eid-ec16adad-34c8456c-80536072-32aeec7d-session-ec16adad-34c8456c-80536072-32aeec7d&rscd=attachment%3B%20filename%3D%22Microsoft.CodeAnalysis.LanguageServer.linux-x64.4.12.0-2.24417.1.nupkg%22&P1=1724037911&P2=1&P3=2&P4=gWMe2EcOpfH3DR3WcrRHHNy7Tdsz8N7QuAZdgHUJfyk%3d"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        ls_url="https://etjvsblobprodwus2172.vsblob.vsassets.io/b-63b6279ad2f14bc3a21cdb7614e92831/270B5B41FCC924B78FFAAEC2E2F6623DDEE782E2EB8AD71C9661A7144E9B399C00.blob?sv=2019-07-07&sr=b&si=1&sig=Y2Eil5keeY2ZyHlm%2FOZPZz%2FfkZhWgII31wn0q0Kuu0g%3D&spr=https&se=2024-08-19T00%3A42%3A54Z&rscl=x-e2eid-0ae75aa5-b81e4f13-bef4006c-4791577b-session-0ae75aa5-b81e4f13-bef4006c-4791577b&rscd=attachment%3B%20filename%3D%22Microsoft.CodeAnalysis.LanguageServer.osx-arm64.4.12.0-2.24417.1.nupkg%22&P1=1724038971&P2=1&P3=2&P4=4%2b936oMTgkM4TFkxnmVVzhCHlRl4L3LpTq2trVyzSMQ%3d"
    elif [[ "$OSTYPE" == "msys"* ]]; then
        ls_url="https://5zivsblobprodwus217.vsblob.vsassets.io/b-63b6279ad2f14bc3a21cdb7614e92831/3B0A5499F08F0E32C42100BAC3294DD3C17C4194871224A924DDD26CDC867F4700.blob?sv=2019-07-07&sr=b&si=1&sig=cgunybBSn1l8ambLaLCHoo2%2FRO6u0pUbhOyeDpsD96k%3D&spr=https&se=2024-08-19T17%3A08%3A32Z&rscl=x-e2eid-df79a781-ea28465c-84c62ad6-e22e3e02-session-df79a781-ea28465c-84c62ad6-e22e3e02&rscd=attachment%3B%20filename%3D%22Microsoft.CodeAnalysis.LanguageServer.win-x64.4.12.0-2.24417.1.nupkg%22&P1=1724098109&P2=1&P3=2&P4=CepdK4jEODdHV3ebOTQH3Z%2b1AyPT7kmcnTeAo0LZuuI%3d"
    mkdir temp
    curl $ls_url\
        -o temp/language_server.nupkg
    cd temp
    unzip temp/language_server.nupkg
    mv temp/content/LanguageServer/linux-x64 $HOME/.local/share/nvim/roslyn
    rm -rf temp
fi

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
