# TODO: import the module defined in prompt/prompt.psd1
Import-Module -Name $PSScriptRoot\prompt.ps1

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
    $response = ynqPrompt -Prompt "Would you like to install Chocolatey package manager?"
    if ($response -eq "q") {
        Write-Host "Exiting..."
        exit 1
    }

    if ($response -eq "y") {
        Write-Host "Installing Chocolatey..."
        Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
        # TODO: Restart the console
    } elseif ($response -eq "n") {
        Write-Host "Not installing Chocolatey. This may be required."
    }
}

# Install VcXsrv
if (Get-Command "C:\Program Files\VcXsrv\xlaunch.exe" -ErrorAction SilentlyContinue) {
    Write-Host "VcXsrv is already installed."
} else {
    $response = ynqPrompt -Prompt "Would you like to install VcXsrv?"
    if ($response -eq "q") {
        Write-Host "Exiting..."
        exit 1
    }

    if ($response -eq "y") {
        Write-Host "Installing VcXsrv..."
        choco install vcxsrv
    } elseif ($response -eq "n") {
        Write-Host "Not installing VcXsrv. This may be required."
    }
    
}

anyKeyPrompt