#!/usr/bin/env zsh
# TODO: Reference only works if called by running main.py
. ./mac/prompt.zsh

# Error handling
# Confirm Docker and related arguments are valid
# $* is the command passed by the -c flag
command=$*
if [ -z $command ]; then
    echo "Please use the -c flag to name the command to run."
    exit 2
fi

which docker > /dev/null
if [ $? -ne 0 ]; then
    echo "Error: Please install docker first."
    exit 2
fi

if [ -z $(docker images | grep -wo $1) ]; then
    echo "Error: The given command is invalid."
    exit 2
fi

docker stats --no-stream > /dev/null
if [ $? -ne 0 ]; then
    echo "Please start the Docker daemon before running this script."
    exit 2
fi

ipaddress=$(ifconfig en0 | grep "inet " | cut -d " " -f2)
if [ -z $ipaddress ]; then
    echo "There was an error retrieving the ip address."
    exit 2
fi

# Confirm necessary software is installed
which socat > /dev/null
if [ $? -ne 0 ]; then
    echo "Error: Please run the install script first."
    exit 2
fi
which xquartz > /dev/null
if [ $? -ne 0 ]; then
    echo "Error: Please run the install script first."
    exit 2
fi

docker_run_cmd="docker run"
prefix=${command%%$docker_run_cmd*}
if [[ $prefix = $command ]]; then
    echo "Error: Please pass an appropriate docker run command to -c."
    exit 2
fi

# Run the X11 environment
socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\" &
open -a XQuartz &

# This runs the docker command
# echo $prefix $docker_run_cmd -e DISPLAY=$ipaddress:0 -v /tmp/.X11-unix:/tmp/.X11-unix${command#$docker_run_cmd*}
eval docker run -e DISPLAY=$ipaddress:0 -v /tmp/.X11-unix:/tmp/.X11-unix${command#$docker_run_cmd*}

# End previously started software
kill -9 $(ps -e | grep "[s]ocat" | cut -d " " -f1)
kill -9 $(ps -e | grep "[X]Quartz.app" | cut -d " " -f1)

anyKeyPrompt