import os

from typing import Union

def setup(args: "dict[str, Union[bool, str]]") -> None:
    present_args = [arg for arg, val in args.items() if val]

    if "install" in present_args:
        os.system("chmod u+x ./mac/install.zsh")
        os.system("./mac/install.zsh")

    if "run" in present_args:
        os.systme("chmod u+x ./mac/run.zsh")
        os.system("./mac/run.zsh")

    if "uninstall" in present_args:
        os.system("chmod u+x ./mac/uninstall.zsh")
        os.system("./mac/uninstall.zsh")


    # Run the X11 environment
    # os.system('socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\"')
    # os.system('open -a XQuartz')
    
    # This runs the docker container
    # docker run -e DISPLAY=$(ifconfig en0 | grep "inet " | cut -d " " -f2):0 -v /tmp/.X11-unix:/tmp/.X11-unix <Container Name>

    # Appears to no longer be needed
    # xauth add $(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}'):0 . $(xauth list | awk '{print $3} NR=1{exit}')

if __name__ == "__main__":
    pass