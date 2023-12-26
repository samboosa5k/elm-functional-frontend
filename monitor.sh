#!/bin/bash

# error="./scripts/error.sh"
build_app="./build.sh"
build_styles="./build_styles.sh"

function watch_changes() {
    # watch for changes in ./styles
    # log a list of files that changed e.g. $log "./src/index.js"

    # watch for changes to scss files in ./styles
    # log a list of files that changed e.g. echo "./styles/index.scss"
    # run $build_styles
    watch -n 1 -d -t -g ./styles/ -e scss -c "$build_styles"
}

alias watch_changes=watch_changes
watch_changes
