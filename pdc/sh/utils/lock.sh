#!/usr/bin/env bash
# shellcheck disable=SC2154

# Configure a lock file, to do not run another PDC process while it is running
pdcdef_lock_file() {
    local lock="/tmp/pdc.lock"

    exec 200>$lock

    flock -n 200 || (
        echo &&
        echo "Error: Can't lock file ${lock}" &&
        echo "Are this installer in execution by other process?" &&
        exit 1
    )
}
