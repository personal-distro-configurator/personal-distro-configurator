#!/usr/bin/env bats

load ../../helper/test_helper

setup() {
    super_setup ".."
    source "${PDC_FOLDER}/sh/steps/_setup.sh"
}

teardown() {
    super_teardown
}

# _step_setup_plugin --------------------------------------------------------
@test "_step_setup_plugin: execute all plugins setup" {
    # variables
    test_file="${TEMP}/test_file"

    # mocks
    eval() { echo "$1" >> "$test_file" ; }
    pdcyml_plugin_setup=( 'cmd1' 'cmd2' 'cmd3' )

    # run
    run _step_setup_plugin

    # asserts
    [ "$status" -eq 0 ]
    [ -f "$test_file" ]
    [ "$(cat $test_file)" != '' ]

    expected[0]='cmd1'
    expected[1]='cmd2'
    expected[2]='cmd3'

    i=0
    while read line; do
        [ "${expected[$i]}" = "$line" ]
        i=$((i + 1))
    done < "$test_file"
}

@test "_step_setup_plugin: test when setup list is empty" {
    # variables
    test_file="${TEMP}/test_file"

    # mocks
    eval() { touch "$test_file" ; }
    pdcyml_plugin_setup=()

    # run
    run _step_setup_plugin

    # asserts
    [ "$status" -eq 0 ]
    [ ! -f "$test_file" ]
}

# setup ----------------------------------------------------------------------
@test "setup: validate execution order" {
    # variables
    test_file="${TEMP}/test_file"

    # mocks
    _step_setup_plugin() { echo "1" >> "$test_file" ; }

    # run
    run setup

    # asserts
    [ "$status" -eq 0 ]
    [ -f "$test_file" ]
    [ "$(cat "$test_file" | cut -d$'\n' -f1)" == '1' ]
}
