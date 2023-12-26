#!/bin/bash

# error="./scripts/error.sh"
log="./scripts/log.sh"
build_app="./build.sh"
build_styles="./build_styles.sh"

function monitor() {
    echo "Monitoring..."
    # use inotifywait to monitor changes at intervals of 5 seconds in the directory ./styles to .scss files
    # and if there is a change, print the filename of the modified file in intervals of 5 seconds
    # if there is no change, then the script will wait for 5 seconds and then check again
    while inotifywait -q -r -e modify ./styles; do
        echo "Change detected"
        # if there is a change, then run the build_styles.sh script
        $build_styles
        # if the build_styles.sh script is successful, then run the build.sh script
        #        if [ $? -eq 0 ]; then
        #            build_app
        #        fi
    done
}

alias monitor=monitor
monitor
