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

# Uninstall VcXsrv
if (Get-Command "C:\Program Files\VcXsrv\xlaunch.exe" -ErrorAction SilentlyContinue) {
    $response = ynqPrompt -Prompt "Would you like to uninstall VcXsrv?"
    if ($response -eq "q") {
        Write-Host "Exiting..."
        exit 1
    }

    if ($response -eq "y") {
        choco uninstall vcxsrv
    } elseif ($response -eq "n") {
        Write-Host "VcXsrv was not uninstalled."
    }
} else {
    Write-Host "VcXsrv is not currently installed."
}

# Uninstall Chocolatey
if (Get-Command choco -ErrorAction SilentlyContinue) {
    $response = ynqPrompt -Prompt "Would you like to uninstall Chocolatey package manager?"
    if ($response -eq "q") {
        Write-Host "Exiting..."
        exit 1
    }

    if ($response -eq "y") {
        Remove-Item $env:ChocolateyInstall -Recurse -Force

        # Update path
        $path = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
        $newPath = ($path.split(";") | Where-Object { $_ -ne "C:\ProgramData\chocolatey\bin" }) -join ";"
        [System.Environment]::SetEnvironmentVariable("Path", $newPath, "Machine")

        # Remove additional environment variables
        [System.Environment]::SetEnvironmentVariable("ChocolateyLastPathUpdate", $null, "User")
        [System.Environment]::SetEnvironmentVariable("ChocolateyToolsLocation", $null, "User")
        [System.Environment]::SetEnvironmentVariable("ChocolateyInstall", $null, "Machine")
    } elseif ($response -eq "n") {
        Write-Host "Chocolatey package manager was not uninstalled."
    }
} else {
    Write-Host "Chocolately is not currently installed."
}

# TODO: The following is for testing purposes only
Write-Host -NoNewline "Press any key to continue..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")