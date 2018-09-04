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

    # run
    run . "${PDC_FOLDER}/sh/steps/steps.sh"

    # asserts
    [ "$status" -eq 0 ]
    [ -f "$test_file" ]
    [ $(cat "$test_file" | grep './sh/steps/_setup.sh') ]
    [ $(cat "$test_file" | grep './sh/steps/_execute.sh') ]
}

@test "steps.sh: validate execution order" {
    # variables
    test_file="${TEMP}/test_file"

    # mocks
    source() { return ; }
    setup() { echo "1" >> "$test_file" ; }

    # run
    run . "${PDC_FOLDER}/sh/steps/steps.sh"

    # asserts
    [ "$status" -eq 0 ]
    [ -f "$test_file" ]
    [ $(cat "$test_file" | cut -d$'\n' -f1) == '1' ]
}

@test "steps.sh: validate unset imports" {
    # imports
    source "${PDC_FOLDER}/sh/steps/_setup.sh"
    source "${PDC_FOLDER}/sh/steps/_execute.sh"

    # variables
    test_file="${TEMP}/test_file"
    test_imports="${TEMP}/test_imports"

    # mocks
    source() { echo 'test' >> "$test_imports" ; }
    setup() { return ; }

    # run
    . "${PDC_FOLDER}/sh/steps/steps.sh"
    declare -F | awk '{print $3}' > "$test_file"

    # asserts
    [ -f "$test_file" ]
    [ $(wc -l < "$test_imports") == 2 ]

    for func in $(cat "$test_file"); do
        [ ! $(cat "${PDC_FOLDER}/sh/steps/_setup.sh" | grep "${func}() {") ]
        [ ! $(cat "${PDC_FOLDER}/sh/steps/_execute.sh" | grep "${func}() {") ]
    done
}
