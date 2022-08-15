param([String]$container="")

$vcxsrvPath ="C:\Program Files\VcXsrv"

if ((Get-Command "${vcxsrvPath}\xlaunch" -ErrorAction SilentlyContinue) -and
    (Get-Command docker -ErrorAction SilentlyContinue)) {
    
    if (Get-Process VcXsrv -ErrorAction SilentlyContinue) {
        Write-Host "VcXsrv is already running."
    } else {
        # Update path and run the X11 environment
        $env:path += ";${vcxsrvPath}"
        xlaunch -run .\\win\\config.xlaunch
    }

    # Run the Docker container
    # TODO: Programatically get the IP address
    # TODO: accept an argument of the container name
    docker run --rm -e DISPLAY=192.168.0.2:0 test-gui
} else {
    Write-Host "Missing Dependencies. Please run the install script first."
    Write-Host -NoNewline "Press any key to continue..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}

# TODO: The following is for testing purposes only
Write-Host -NoNewline "Press any key to continue..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")