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
    choco uninstall vcxsrv
} else {
    Write-Host "VcXsrv is not currently installed."
}

# Uninstall Chocolatey
if (Get-Command choco -ErrorAction SilentlyContinue) {
    # TODO: Uninstall choco
    # TODO: Delete C:\ProgramData\chocolatey or whatever $env:Chocolatey resolves to
    # TODO: Remove ChocolateyInstall, ChocolateyToolsLocation, ChocolateyLastPathUpdate environment variables
    # TODO: Update Path
} else {
    Write-Host "Chocolately is not currently installed."
}

# TODO: The following is for testing purposes only
Write-Host -NoNewline "Press any key to continue..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")