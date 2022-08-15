import os


def setup():
    # Confirm docker is ready
    if os.system('systemctl is-active docker'):
        if os.system('systemctl start docker'):
            print('Attempting to start Docker')
            exit(2)
        if os.system('systemctl is-active docker'):
            print('Unable to start Docker. Please start Docker, then run again')
            exit(2)

    # Setup the X11 environment
    os.system('xhost +local:*')

    # Run the Docker container
    os.system('docker run -it --net=host -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix gui-test')

    # Cleanup X11 environment
    os.system('xhost -local:*')


if __name__ == '__main__':
    pass