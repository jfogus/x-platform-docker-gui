$windowId = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$windowPrincipal = New-Object System.Security.Principal.WindowsPrincipal($windowId)

$adminRole = [System.Security.Principal.WindowsBuiltInRole]::Administrator
if ($windowPrincipal.IsInRole($adminRole)) {
    # Privileges are elevated, ensure screen appearance reflects this
    $Host.UI.RawUI.WindowTitle = $MyInvocation.MyCommand.Definition + "(Elevated)"
    clear-host
} else {
    # Privileges are not elevated, elevate them and restar the process
    $newProcess = New-Object System.Diagnostics.ProcessStartInfo "PowerShell"
    $newProcess.Arguments = $MyInvocation.MyCommand.Definition
    $newProcess.Verb = "runas"

    [System.Diagnostics.Process]::Start($newProcess)
    exit
}

# Install Chocolatey
if (Get-Command choco -ErrorAction SilentlyContinue) {
    Write-Host "Chocolately is already installed."
} else {
    $response = ""
    while ($response -eq "") {
        Write-Host "Would you like to install Chocolatey package manager? [y/n/q] " -NoNewline

        $response = Read-Host
        $response = $response.ToLower()

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
        Write-Host -NoNewline "Press any key to continue..."
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        exit 1
    }
}

# Install VcXsrv
# TODO: Update path to incldue vcxsrv folder
if (Get-Command "C:\Program Files\VcXsrv\xlaunch.exe" -ErrorAction SilentlyContinue) {
    Write-Host "VcXsrv is already installed."
} else {
    choco install vcxsrv
}

# TODO: The following is for testing purposes only
Write-Host -NoNewline "Press any key to continue..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")