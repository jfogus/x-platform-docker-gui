import os

def setup():
    # Install Dependencies
    print("\nChecking for brew installation:", end=" ", flush=True)
    if (os.system('which brew') == 0):
        print("\tBrew is already installed")
    else:
        print("\n\tInstalling brew")
        os.system('/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"')

    print("\nChecking for socat installation:", end=" ", flush=True)
    if (os.system('which socat') == 0):
        print("\tSocat is already installed")
    else:
        print("\n\tInstalling socat")
        os.system('brew install socat')

    print("\nChecking for XQuartz installation:", end=" ", flush=True)
    if (os.system('which xquartz') == 0):
        print("\tXQuartz is already installed")
    else:
        print("\n\tInstalling XQuartz")
        os.system('brew install --cask xquartz')

    # Requires a restart probably

    # Run the X11 environment
    os.system('socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\"')
    os.system('open -a XQuartz')
    
    # This runs the docker container
    # docker run -e DISPLAY=$(ifconfig en0 | grep "inet " | cut -d " " -f2):0 -v /tmp/.X11-unix:/tmp/.X11-unix <Container Name>

    # Appears to no longer be needed
    # xauth add $(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}'):0 . $(xauth list | awk '{print $3} NR=1{exit}')

if __name__ == "__main__":
    pass