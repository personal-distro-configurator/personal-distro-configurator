#!/usr/bin/env bats

load ../../helper/test_helper

setup() {
    super_setup ".."
    source "${PDC_FOLDER}/sh/init/_lockfile.sh"
}

teardown() {
    super_teardown
}

# lockfile -----------------------------------------------------------
@test "lockfile: lock file must be created" {
    run lockfile

    [ -f "/tmp/pdc.lock" ]
    [ "$status" -eq 0 ]
}

@test "lockfile: error on try to create two times a lock file" {
    lockfile
    run lockfile

    [ "$status" -eq 1 ]
}
