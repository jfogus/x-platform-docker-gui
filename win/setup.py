import subprocess

from typing import Union


def setup(args: "dict[str, Union[bool, str]]") -> None:
    present_args = [arg for arg, val in args.items() if val]

    try:
        # Get current ExecutionPolicy to reset after script
        proc = subprocess.Popen(["powershell.exe", "-Command", "Get-ExecutionPolicy"], stdout=subprocess.PIPE)
        policy = proc.communicate()[0].strip().decode('utf-8')

        # Set ExecutionPolicy for Running the setup script
        proc = subprocess.Popen(["PowerShell.exe", "-Command", "Set-ExecutionPolicy -Scope CurrentUser ByPass"])
        proc.wait()

        # Run the script
        if "install" in present_args:
            proc = subprocess.Popen(["PowerShell.exe", "-Command", ".\\win\\install.ps1"])
            proc.wait()

        if "run" in present_args:
            command = ".\\win\\run.ps1 \"{}\"".format(args['container']) if args['container'] else ".\\win\\run.ps1"
            proc = subprocess.Popen(["PowerShell.exe", "-Command", command])
            proc.wait()

        if "uninstall" in present_args:
            proc = subprocess.Popen(["PowerShell.exe", "-Command", ".\\win\\uninstall.ps1"])
            proc.wait()

        # Reset ExecutionPolicy
        proc = subprocess.Popen(["PowerShell.exe", "-Command", "Set-ExecutionPolicy -Scope CurrentUser {}".format(policy)])
        proc.wait()

    except:
        print("Failed to run setup script")


if __name__ == "__main__":
    pass