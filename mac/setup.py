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


if __name__ == "__main__":
    pass
