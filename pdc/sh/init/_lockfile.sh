#!/usr/bin/env bash

lockfile() {
    local lock="/tmp/pdc.lock"

    exec 200>$lock

    flock -n 200 || (
        echo &&
        echo "Error: Can't lock file ${lock}" &&
        echo "Are this installer in execution by other process?" &&
        exit 1
    )
}
