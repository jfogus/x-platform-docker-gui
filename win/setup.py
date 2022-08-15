import subprocess


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

        proc = subprocess.Popen(["PowerShell.exe", "-Command", ".\\win\\run.sp1"])
        proc.wait()

        # Reset ExecutionPolicy
        proc = subprocess.Popen(["PowerShell.exe", "-Command", "Set-ExecutionPolicy -Scope CurrentUser {}".format(policy)])
        proc.wait()

    except:
        print("Failed to run setup script")


if __name__ == "__main__":
    pass