#!/usr/bin/env bats

load ../../helper/test_helper

setup() {
    super_setup ".."
    source "${PDC_FOLDER}/sh/init/_import.sh"
}

teardown() {
    super_teardown
}

# _plugin_import -------------------------------------------------------
@test "_plugin_import: import all files" {
    # variables
    test_file="${TEMP}/test_file"

    # mocks
    source() { echo "$1" >> "$test_file" ; }
    pdcyml_plugin_import=( 'file1' 'file2' 'file3' )

    # run
    run _plugin_import

    # asserts
    [ "$status" -eq 0 ]
    [ -f "$test_file" ]
    [ "$(cat $test_file)" != '' ]

    expected[0]='file1'
    expected[1]='file2'
    expected[2]='file3'

    i=0
    while read line; do
        [ "${expected[$i]}" = "$line" ]
        i=$((i + 1))
    done < "$test_file"
}

@test "_plugin_import: test when import list is empty" {
    # variables
    test_file="${TEMP}/test_file"

    # mocks
    source() { touch "$test_file" ; }
    pdcyml_plugin_import=()

    # run
    run _plugin_import

    # asserts
    [ "$status" -eq 0 ]
    [ ! -f "$test_file" ]
}

# _user_import -------------------------------------------------------------
@test "_user_import: must import one file" {
    # variables
    file1="${RESOURCES}/setup/sh/file1.sh"

    # mocks
    pdcyml_import=( "$file1" )

    # run
    run _user_import

    # asserts
    [ "$status" -eq 0 ]
    [ -f "${TEMP}/file1" ]
}

@test "_user_import: must import many files" {
    # variables
    file1="${RESOURCES}/setup/sh/file1.sh"
    file2="${RESOURCES}/setup/sh/file2.sh"
    file3="${RESOURCES}/setup/sh/file3.sh"

    # mocks
    pdcyml_import=( "$file1" "$file2" "$file3" )

    # run
    run _user_import

    # asserts
    [ "$status" -eq 0 ]
    [ -f "${TEMP}/file1" ]
    [ -f "${TEMP}/file2" ]
    [ -f "${TEMP}/file3" ]
}

@test "_user_import: must run without import any file" {
    # mocks
    pdcyml_import=( )

    # run
    run _user_import

    # asserts
    [ "$status" -eq 0 ]
}
