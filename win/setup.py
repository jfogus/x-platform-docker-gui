import subprocess
import os

def setup():
    # Install Dependencies
    try:
        # Get current ExecutionPolicy to reset after script
        proc = subprocess.Popen(["powershell.exe", "-Command", "Get-ExecutionPolicy"], stdout=subprocess.PIPE)
        policy = proc.communicate()[0].strip().decode('utf-8')

        # Set ExecutionPolicy for Running the setup script
        proc = subprocess.Popen(["PowerShell.exe", "-Command", "Set-ExecutionPolicy -Scope CurrentUser ByPass"])
        proc.wait()

        # Run the script
        proc = subprocess.Popen(["PowerShell.exe", "-Command", ".\\win\\setup.ps1"])
        proc.wait()

        # Reset ExecutionPolicy
        proc = subprocess.Popen(["PowerShell.exe", "-Command", "Set-ExecutionPolicy -Scope CurrentUser {}".format(policy)])
        proc.wait()

        # proc = subprocess.Popen(["pwsh.exe"], stdout=sys.stdout)
        # proc.communicate()
        # os.system("pwsh.exe -ExecutionPolicy")
        # rc = os.system("powershell.exe ./win/setup.ps1")
        # proc = subprocess.Popen(["powershell.exe", "./win/setup.ps1"], stdout=sys.stdout, stderr=None)
        
        # proc.communicate()
        # print(proc.returncode)
    except:
        print("Failed to run setup script")

    # Requires a restart probably

    # Run the X11 environment

    # Run the Docker container


if __name__ == "__main__":
    # TODO: Change this to only pass
    setup()
    pass