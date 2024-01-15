#!/bin/bash

function build() {

    local output_name="elm.js"
    local command="elm make src/Main.elm --output=dist/$output_name"

    $command
}

alias build=build
build
