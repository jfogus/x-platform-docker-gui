#!/usr/bin/env bash
# TODO: Reference only works when run directly
. ./lin/prompt.sh

# Error handling
# Confirm docker and related arguments are valid
# $1 is the container passed by the -c flag
container=$1
if [ -z $container ]; then
    echo "Please use the -c flag to name the container to run."
    exit 2
fi

which docker > /dev/null
if [ $? -ne 0 ]; then
    echo "Error: Please install docker first."
    exit 2
fi

if [ $(systemctl is-active docker) = "inactive" ]; then
    echo "Attempting to start Docker."
    systemctl start docker
    if [ $? -ne 0 ]; then
        echo "Unable to start Docker daemon. Please start it manually, then run again."
        exit 2
    fi
fi

if [ -z $(docker images | grep -wo $container) ]; then
    echo "Error: The given container name is invalid."
    exit 2
fi

docker stats --no-stream > /dev/null
if [ $? -ne 0 ]; then
    echo "Please start the docker daemon before running this script."
    exit 2
fi

xhost +local:root

docker run --rm -it --net=host -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix $container

xhost -local:root

anyKeyPrompt