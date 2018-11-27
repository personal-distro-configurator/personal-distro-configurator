#!/usr/bin/env bats

load ../../helper/test_helper

setup() {
    super_setup ".."
}

teardown() {
    super_teardown
}

# steps.sh -------------------------------------------------------------------
@test "steps.sh: validate imports" {
    # variables
    test_file="${TEMP}/test_file"

    # mocks
    source() { echo "$@" >> "$test_file" ; }
    execute() { return ; }

    # run
    run . "${PDC_FOLDER}/sh/steps/steps.sh"

    # asserts
    [ "$status" -eq 0 ]
    [ -f "$test_file" ]
    [ $(cat "$test_file" | grep './sh/steps/_execute.sh') ]
}

@test "steps.sh: validate unset imports" {
    # imports
    source "${PDC_FOLDER}/sh/steps/_execute.sh"

    # variables
    test_file="${TEMP}/test_file"
    test_imports="${TEMP}/test_imports"

    # mocks
    source() { echo 'test' >> "$test_imports" ; }
    execute() { return ; }

    # run
    . "${PDC_FOLDER}/sh/steps/steps.sh"
    declare -F | awk '{print $3}' > "$test_file"

    # asserts
    [ -f "$test_file" ]
    [ $(wc -l < "$test_imports") == 1 ]

    for func in $(cat "$test_file"); do
        [ ! $(cat "${PDC_FOLDER}/sh/steps/_execute.sh" | grep "${func}() {") ]
    done
}
