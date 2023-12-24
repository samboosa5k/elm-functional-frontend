#!/bin/bash

function error() {
    local message
    local details

    if [[ $# -eq 0 ]]; then
        return 1
    fi

    if [[ $# -eq 1 ]]; then
        message="$1"
        # Print message
        printf "Error: %s\n" "$message"
    elif [[ $# -eq 2 ]]; then
        message="$1"
        details="$2"
        # Print message and details
        printf "Error: %s\n\n%s\n" "$message" "$details"
    else
        message="Unknown error"
        # Print message
        printf "Error: %s\n" "$message"
    fi

    return 0
}

alias error=error
error "$@"
