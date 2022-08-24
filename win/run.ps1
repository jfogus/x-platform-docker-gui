param([String]$container="")

Import-Module -Name $PSScriptRoot\prompt.ps1
Import-Module -Name $PSScriptRoot\validate.ps1

$vcxsrvPath ="C:\Program Files\VcXsrv"

if ((Get-Command "${vcxsrvPath}\xlaunch" -ErrorAction SilentlyContinue) -and
    (Get-Command docker -ErrorAction SilentlyContinue)) {

    if ($container -eq "") {
        Write-Host "Please use the --container flag with the --run flag."
        Write-Host -NoNewline "Press any key to continue..."
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        exit 1
    }

    # Method of getting IP address from:
    # https://www.delftstack.com/howto/powershell/powershell-get-ip-address/#:~:text=variable%20in%20PowerShell.-,Use%20Get%2DNetIPAddress%20to%20Get%20IPv4%20Address%20Into%20a%20Variable,IP%20interfaces%20associated%20with%20addresses.
    # TODO: Returns 2 ip addresses when VirtualBox is installed. Try to get the correct one.
    # $ipAddress = openPrompt -Prompt "Please enter your local IP address"
    # $ipAddress = Get-NetIPAddress -AddressFamily IPv4 -InterfaceIndex $(Get-NetConnectionProfile | Select-Object -ExpandProperty InterfaceIndex) | Select-Object -ExpandProperty IPAddress
    $ipAddress = validatePrompt -Validator $function:validateIPv4Address -Prompt "Please enter your local IP address"

    # Start X server
    if (Get-Process VcXsrv -ErrorAction SilentlyContinue) {
        Write-Host "VcXsrv is already running."
    } else {
        # Update path and run the X11 environment
        $env:path += ";${vcxsrvPath}"
        xlaunch -run .\\win\\config.xlaunch
    }

    # Run the Docker container
    $cmd ="docker run"
    $index_of_cmd = $container.IndexOf($cmd)
    Invoke-Expression "$($container.SubString(0, $index_of_cmd)) $cmd -e DISPLAY=${ipAddress}:0$($container.Substring($index_of_cmd + $cmd.Length))"
} else {
    Write-Host "Missing Dependencies. Please run the install script first."
    Write-Host -NoNewline "Press any key to continue..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}

# TODO: The following is for testing purposes only
Write-Host -NoNewline "Press any key to continue..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")