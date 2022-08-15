# Process elevation from https://docs.microsoft.com/en-us/archive/blogs/virtual_pc_guy/a-self-elevating-powershell-script
$windowId = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$windowPrincipal = new-object System.Security.Principal.WindowsPrincipal($windowId)

$adminRole = [System.Security.Principal.WindowsBuiltInRole]::Administrator
if ($windowPrincipal.IsInRole($adminRole)) {
    # Privileges are elevated, ensure screen appearance reflects this
    $Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + "(Elevated)"
    # $Host.UI.RawUI.BackgroundColor = "DarkBlue"
    clear-host
} else {
    # Privileges are not elevated, elevate them and restart the process
    $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell"
    $newProcess.arguments = $myInvocation.MyCommand.Definition
    $newProcess.verb = "runas"

    [System.Diagnostics.Process]::Start($newProcess)
    exit
}

# Install Chocolatey
if (Get-Command choco -ErrorAction SilentlyContinue) {
    Write-Host "Chocolatey is already installed."
}
else {
    $response = ""
    while ($response -eq "") {
        write-Host "Would you like to install Chocolatey package manager? [y/n/q] " -NoNewline

        $response = Read-Host
        $response = $response.toLower()

        if ($response -eq "q") {
            Write-Host "Exiting..."
            exit 1
        } elseif (-Not ("y", "n").Contains($response)) {
            Write-Host "Please enter a valid response."
            $response = ""
        }
    }

    if ($response -eq "y") {
        Write-Host "Installing Chocolatey..."
        Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
        # TODO: Restart the console
    } elseif ($response -eq "n") {
        Write-Host "Please install VcXsrv manually."
        Write-Host -NoNewLine "Press any key to continue..."
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        exit 1
    }
}

# Install VcXsrv
# TODO: Update path to include vcxsrv folder
if (Get-Command "C:\Program Files\VcXsrv\xlaunch.exe" -ErrorAction SilentlyContinue) {
    Write-Host "VcXsrv is already installed."
} else {
    choco install vcxsrv
}

# TODO: The following is for testing purposes only
Write-Host -NoNewLine "Press any key to continue..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")