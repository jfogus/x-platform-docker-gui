function ynqPrompt {
    param(
        [String] $Prompt
    )

    $response = ""
    while ($response -eq "") {
        Write-Host -NoNewline "$Prompt [y/n/q] "

        $response = Read-Host
        $response = $response.ToLower()

        if (-Not ("y", "n", "q").Contains($response)) {
            Write-Host "Please enter a valid response."
            $response = ""
        }
    }

    return $response
}

function anyKeyPrompt {
    param()

    Write-Host -NoNewline "Press any key to continue..."
    &null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

function openPrompt {
    param(
        [String] $Prompt
    )

    Write-Host -NoNewline "${Prompt}: "
    $response = Read-Host

    return $response
}