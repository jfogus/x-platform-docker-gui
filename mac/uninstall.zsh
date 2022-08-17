#!/usr/bin/env zsh
# TODO: Reference only works if called by running main.py
. ./mac/prompt.zsh

# Uninstall XQuartz
ynqPrompt "Uninstall XQuartz?"

if [ $response = "q" ]; then
    echo "Exiting..."
    exit 1
fi

if [ $response = "y" ]; then
    brew uninstall --cask xquartz
else
    echo "XQuartz was not uninstalled."
fi

# Uninstall Socat
ynqPrompt "Uninstall Socat?"

if [ $response = "q" ]; then
    echo "Exiting..."
    exit 1
fi

if [ $response = "y" ]; then
    brew uninstall socat
else
    echo "Socat was not uninstalled."
fi

# Uninstall Brew
ynqPrompt "Uninstall Brew?"

if [ $response = "q" ]; then
    echo "Exiting..."
    exit 1
fi

if [ $response = "y" ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
else
    echo "Brew was not uninstalled."
fi