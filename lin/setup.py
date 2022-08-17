import os

from typing import Union


def setup(args: "dict[str, Union[bool, str]]") -> None:
    present_args = [arg for arg, val in args.items() if val]

    if "install" in present_args:
        os.system("chmod u+x ./lin/install.sh")
        os.system("./lin/install.sh")

    if "run" in present_args:
        command = "./lin/run.sh {}".format(args['container'] if args['container'] else "./lin/run.sh")
        os.system("chmod u+x ./lin/run.sh")
        os.system(command)
    
    if "uninstall" in present_args:
        os.system("chmod u+x ./lin/uninstall.sh")
        os.system("./lin/uninstall.sh")


if __name__ == '__main__':
    pass