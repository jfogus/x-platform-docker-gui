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