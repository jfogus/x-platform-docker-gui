#!/usr/bin/env zsh

# Run the X11 environment
# os.system('socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\"')
# os.system('open -a XQuartz')

# This runs the docker container
# docker run -e DISPLAY=$(ifconfig en0 | grep "inet " | cut -d " " -f2):0 -v /tmp/.X11-unix:/tmp/.X11-unix <Container Name>

# Appears to no longer be needed
# xauth add $(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}'):0 . $(xauth list | awk '{print $3} NR=1{exit}')