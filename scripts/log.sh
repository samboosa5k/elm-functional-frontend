#!/bin/bash

function log() {
    local message
    local details

    if [[ $# -eq 0 ]]; then
        return 1
    fi

    if [[ $# -eq 1 ]]; then
        message="$1"
        # Print message
        printf "Log: %s\n" "$message"
    elif [[ $# -eq 2 ]]; then
        message="$1"
        details="$2"
        # Print message and details
        printf "Log: %s\n\n%s\n" "$message" "$details"
    else
        local arg
        # For loop to print all arguments
        for arg in "$@"; do
            printf "Log: %s\n" "$arg"
        done
    fi
}

alias log=log
log "$@"
