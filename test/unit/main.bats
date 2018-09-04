#!/usr/bin/env bats

load ../helper/test_helper

setup() {
    super_setup "."
}

teardown() {
    super_teardown
}

# main.sh --------------------------------------------------------------------
@test "main.sh: validate exports variables" {
    # mocks
    cd "${TEMP}"

    source() { return ; }
    cd() { return ; }
    set() { return ; }
    exit() { return ; }

    # run
    . "${PDC_FOLDER}/main.sh"

    # asserts
    [ $(readlink -f "$PDCCONST_RUNNING_DIR") == $(readlink -f "$TEMP") ]
    [ $(readlink -f "$PDCCONST_PDC_DIR") == $(readlink -f "${PDC_FOLDER}") ]
}

@test "main.sh: validate imports" {
    # variables
    test_file="${TEMP}/test_file"

    # mocks
    source() { echo "$@" >> "$test_file" ; }
    cd() { return ; }
    set() { return ; }
    exit() { return ; }

    # run
    run . "${PDC_FOLDER}/main.sh"

    # asserts
    [ "$status" -eq 0 ]
    [ -f "$test_file" ]
    [ $(cat "$test_file" | grep './sh/lib/executor.sh') ]
    [ $(cat "$test_file" | grep './sh/lib/log.sh') ]
    [ $(cat "$test_file" | grep './sh/lib/yaml.sh') ]
}

@test "main.sh: validate execution order" {
    # variables
    test_file="${TEMP}/test_file"

    # mocks
    source() {
        [ "$1" == "./sh/init/init.sh" ] && echo "1" >> "$test_file"
        [ "$1" == "./sh/steps/steps.sh" ] && echo "2" >> "$test_file"
    }
    cd() { return ; }
    set() { return ; }
    exit() { return ; }

    # run
    run . "${PDC_FOLDER}/main.sh"

    # asserts
    [ "$status" -eq 0 ]
    [ -f "$test_file" ]

    count=0
    while read line; do
        [ "$line" == $((count+=1)) ]
    done < "$test_file"
}
