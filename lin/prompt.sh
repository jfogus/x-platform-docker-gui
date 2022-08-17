#!/usr/bin/env bash
function ynqPrompt() {
    response=""
    while [ "$response" = "" ]; do
        local valid_responses=(y n q)

        echo -n "$1 [y/n/q] "
        read response
        response=$(tr '[:upper:]' '[:lower:]' <<< $response)

        if [[ ! ${valid_responses[*]} =~ $response ]]; then
            echo "Please enter a valid response."
            response=""
        fi
    done
}

function anyKeyPrompt() {
    echo "Press any key to continue..."
    read -sn 1
}