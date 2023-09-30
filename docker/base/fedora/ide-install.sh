#!/bin/bash

if [ $FLEET == "true" ]; then
    echo "Installing IDE Fleet"
    cd /usr/bin 
    if [ "$(uname -m)" == "aarch64" ]; then 
        curl -LSs "https://download.jetbrains.com/product?code=FLL&release.type=eap&platform=linux_aarch64" --output fleet;
        chmod +x fleet; 
    else 
        curl -LSs "https://download.jetbrains.com/product?code=FLL&release.type=eap&platform=linux_x64" --output fleet;
        chmod +x fleet; 
    fi;
    cd
else
    echo "Fleet not selected"
fi;

if [ $VSCODE == "true" ]; then
    echo "Installing IDE Visual Studio Code"
    wget -O- https://aka.ms/install-vscode-server/setup.sh | sh
else
    echo "Visual Studio Code not selected"
fi;
