#!/bin/bash

log_info="./scripts/log.sh"
log_error="./scripts/error.sh"

function install() {
    # Check if deps dir exists, if not create it
    if [[ ! -d ./deps/ ]]; then
        $log_error "Directory ./deps/ not found"
        $log_info "Creating ./deps/"
        # Create deps dir
        mkdir ./deps/
    else
        $log_error "Directory ./deps/ found"
        $log_info "Not creating ./deps/"
    fi

    # Check if elm exists at ./deps/
    if [[ ! -f ./deps/elm ]]; then
        $log_error "Elm not found at ./deps/elm"
        $log_info "Downloading elm"
        # Download elm
        curl -L -o ./deps/elm.gz https://github.com/elm/compiler/releases/download/0.19.1/binary-for-linux-64-bit.gz
        gunzip ./deps/elm.gz
        chmod +x ./deps/elm
    else
        $log_error "Elm found at ./deps/elm"
        $log_info "Not downloading elm"
    fi

    # Check if dart-sass exists at ./deps/
    if [[ ! -d ./deps/dart-sass ]]; then
        $log_error "Dart-sass not found at ./deps/dart-sass"
        $log_info "Downloading dart-sass"
        # Download dart-sass
        curl -L https://github.com/sass/dart-sass/releases/download/1.69.5/dart-sass-1.69.5-linux-x64.tar.gz | tar -xz -C ./deps/
        chmod +x ./deps/dart-sass/sass
    else
        $log_error "Dart-sass found at ./deps/dart-sass"
        $log_info "Not downloading dart-sass"
    fi

    return 0
}

alias install=install
install
