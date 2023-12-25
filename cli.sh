#!/bin/bash

log="./scripts/log.sh"
error="./scripts/error.sh"

build="./build.sh"
build_styles="./build_styles.sh"

# function cli() {
#     local command=$1
#     local args=$2

#     case $command in
#         "install")
#             $log "Installing"
#             ./scripts/install.sh
#             ;;
#         "build")
#             $log "Building"
#             ./scripts/build.sh
#             ;;
#         "run")
#             $log "Running"
#             ./scripts/run.sh
#             ;;
#         *)
#             $error "Command not found"
#             ;;
#     esac
# }

function cli() {

    local error

    $log "Building styles"
    $build_styles

    # Check if errors occurred in $build_styles output
    error=$(echo $?)

    if [[ $error -ne 0 ]]; then
        $error "Error building styles"
        exit 1
    fi

    $log "Building app"
    $build

    # Check if errors occurred in $build output
    error=$(echo $?)
    if [[ $error -ne 0 ]]; then
        $error "Error building app"
        exit 1
    fi

    $log "Building styles and app complete"
    return 0
}

alias cli=cli
cli
