#!/usr/bin/env zsh

# Install Brew
echo -n "Checking for brew installation: "
which brew
if [ $? -eq 0 ]; then
    echo -e "\tBrew is already installed"
else
    echo -e "\n\tInstalling brew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install Socat
echo -n "Checking for socat installation: "
which socat
if [ $? -eq 0 ]; then
    echo -e "\tSocat is already installed"
else
    echo -e "\n\tInstalling socat"
    brew install socat
fi

# Install XQuartz
echo -n "Checking for XQuartz installation: "
which xquartz
if [ $? -eq 0 ]; then
    echo -e "\tXQuartz is already installed"
else
    echo -e "\n\tInstalling XQuartz"
    brew install --cask xquartz
fi

# Might require a restart (system or terminal?)
