#!/bin/bash

log="./scripts/log.sh"
# error="./scripts/error.sh"
build_app="./build.sh"
build_styles="./build_styles.sh"

function watch_changes() {
    local interval
    local init_time
    interval=2
    init_time=$(date +%s)

    local scss_files
    scss_files=""

    local modified_time
    modified_time=""

    while true; do
        modified_time=$(find ./styles -type f -exec stat -c "%Y" {} \; | sort -n | tail -1)

        if [[ $modified_time -gt $init_time ]]; then
            if [[ $scss_files == "" ]]; then
                scss_files=$(find ./styles -type f -exec stat -c "%Y %n" {} \; | sort -n | tail -1 | cut -d " " -f 2)
                $log "scss_files:" "$scss_files"
            else
                scss_files=$(find ./styles -type f -exec stat -c "%Y %n" {} \; | sort -n | tail -1 | cut -d " " -f 2)
            fi
            $build_styles
            interval=2
            init_time=$modified_time
        else
            $log "interval: $interval"
        fi
        sleep $interval
    done
}

alias watch_changes=watch_changes
watch_changes
