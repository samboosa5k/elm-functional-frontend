#!/bin/bash

function build_styles() {

    local output_name="styles.css"
    local command="./deps/dart-sass/sass styles/style.scss"

    $command $output_name
}

alias build_styles=build_styles
build_styles
