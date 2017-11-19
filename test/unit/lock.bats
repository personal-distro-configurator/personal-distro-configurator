#!/usr/bin/env bats

load ../helper/test_helper

setup() {
    super_setup
    source "${PDC_FOLDER}/sh/utils/lock.sh"
}

teardown() {
    super_teardown
}

# pdcdef_lock_file -----------------------------------------------------------
@test "pdcdef_lock_file: lock file must be created" {
    run pdcdef_lock_file

    [ -f "/tmp/pdc.lock" ]
    [ "$status" -eq 0 ]
}

@test "pdcdef_lock_file: error on try to create two times a lock file" {
    pdcdef_lock_file
    run pdcdef_lock_file

    [ "$status" -eq 1 ]
}
