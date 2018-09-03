#!/usr/bin/env bats

load ../../helper/test_helper

setup() {
    super_setup ".."
    source "${PDC_FOLDER}/sh/init/_setup.sh"
}

teardown() {
    super_teardown
}

# create_variables --------------------------------------
@test "create_variables: must call function to create all variables" {
    #variables
    test_file="${TEMP}/test"

    #mocks
    pdcdef_yaml_createvariables() { echo "$1" > "$test_file" ; }

    # run
    run create_variables

    # asserts
    [ "$status" -eq 0 ]
    [ "$(cat "$test_file")" = 'settings.yml' ]
}

# create_paths --------------------------------------------------------
@test "create_paths: test call functions and order" {
    # variables
    test_file="${TEMP}/test_file"

    # mocks
    pdcyml_path_root='first'
    pdcyml_path_log='second'
    _create_if_not_exists() { echo "$1" >> "$test_file" ; }

    # run
    run create_paths

    # asserts
    [ "$status" -eq 0 ]
    [ -f "$test_file" ]
    [ "$(cat "$test_file")" != '' ]

    expected[0]='first'
    expected[1]='second'

    i=0
    while read line; do
        [ "${expected[$i]}" = "$line" ]
        i=$((i + 1))
    done < "$test_file"
}

# _create_if_not_exists ------------------------------------------------
@test "_create_if_not_exists: create folder" {
    # variables
    path_="${TEMP}/folder"

    # run
    run _create_if_not_exists "$path_"

    # asserts
    [ "$status" -eq 0 ]
    [ -d "$path_" ]
}

@test "_create_if_not_exists: create recursive folder" {
    # variables
    path_="${TEMP}/folder/recursive"

    # run
    run _create_if_not_exists "$path_"

    # asserts
    [ "$status" -eq 0 ]
    [ -d "$path_" ]
}

@test "_create_if_not_exists: do not create folder when exists" {
    # variables
    path_="${TEMP}/folder"
    wrong="${TEMP}/wrong"
    mkdir "$path_"

    # mocks
    mkdir() { touch  ; }

    # run
    run _create_if_not_exists "$path_"

    # asserts
    [ "$status" -eq 0 ]
    [ ! -d "$wrong" ]
}
