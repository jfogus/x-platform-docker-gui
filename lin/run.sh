#!/usr/bin/env bash
# TODO: Reference only works when run from main.py
. ./lin/prompt.sh

# Error handling
# Confirm docker and related arguments are valid
# $1 is the container passed by the -c flag
container=$*
if [ -z "$container" ]; then
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

docker stats --no-stream > /dev/null
if [ $? -ne 0 ]; then
    echo "Please start the docker daemon before running this script."
    exit 2
fi

docker_run_cmd="docker run"
prefix=${container%%$docker_run_cmd*}
if [[ $prefix = $container ]]; then
    echo "Error: Please pass an appropriate docker run command to -c."
    exit 2
fi

xhost +local:root

eval $prefix $docker_run_cmd -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix ${container#*$docker_run_cmd}

xhost -local:root

anyKeyPrompt