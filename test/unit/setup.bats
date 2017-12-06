#!/usr/bin/env bats

load ../helper/test_helper

setup() {
    super_setup
    source "${PDC_FOLDER}/sh/init/setup.sh"

    log_verbose() { echo ; }
    log_info() { echo ; }
}

teardown() {
    super_teardown
}

# pdcdef_setup_create_variables_default --------------------------------------
@test "pdcdef_setup_create_variables_default: must call function to create all variables" {
    #variables
    test_file="${TEMP}/test"

    #mocks
    pdcdef_create_variables() { echo "$1" > "$test_file" ; }

    # run
    run pdcdef_setup_create_variables_default

    # asserts
    [ "$status" -eq 0 ]
    [ "$(cat "$test_file")" = 'settings.yml' ]
}

# pdcdef_setup_create_variables_plugins --------------------------------------
@test "pdcdef_setup_create_variables_plugins: create variable on one plugin" {
    # variables
    test_file="${TEMP}/test_file"

    # mocks
    pdcyml_path_plugins="${RESOURCES}/setup/plugins/one"
    pdcdef_create_variables() { echo "$1" > "$test_file" ; }

    # run
    run pdcdef_setup_create_variables_plugins

    # asserts
    [ "$status" -eq 0 ]
    [ "$(cat "$test_file")" = "${pdcyml_path_plugins}/pdc-a-plugin/plugin.yml" ]
}

@test "pdcdef_setup_create_variables_plugins: dont create variables when plugin.yml not found" {
    # variables
    test_file="${TEMP}/test_file"

    # mocks
    pdcyml_path_plugins="${RESOURCES}/setup/plugins/zero"
    pdcdef_create_variables() { echo "$1" > "$test_file" ; }

    # run
    run pdcdef_setup_create_variables_plugins

    # asserts
    [ "$status" -eq 0 ]
    [ ! -f "$test_file" ]
}

@test "pdcdef_setup_create_variables_plugins: dont create variables when no plugins found" {
    # variables
    test_file="${TEMP}/test_file"

    # mocks
    pdcyml_path_plugins="${RESOURCES}/setup/plugins/none"
    pdcdef_create_variables() { echo "$1" > "$test_file" ; }

    # run
    run pdcdef_setup_create_variables_plugins

    # asserts
    [ "$status" -eq 0 ]
    [ ! -f "$test_file" ]
}

@test "pdcdef_setup_create_variables_plugins: create variables for all plugins" {
    # variables
    test_file="${TEMP}/test_file"

    # mocks
    pdcyml_path_plugins="${RESOURCES}/setup/plugins/many"
    pdcdef_create_variables() { echo "$1" >> "$test_file" ; }

    # run
    run pdcdef_setup_create_variables_plugins

    # asserts
    [ "$status" -eq 0 ]
    [ -f "$test_file" ]
    [ "$(cat $test_file)" != '' ]

    expected[0]="${pdcyml_path_plugins}/pdc-a-plugin/plugin.yml"
    expected[1]="${pdcyml_path_plugins}/pdc-b-plugin/plugin.yml"
    expected[2]="${pdcyml_path_plugins}/pdc-c-plugin/plugin.yml"

    i=0
    while read line; do
        [ "${expected[$i]}" = "$line" ]
        i=$((i + 1))
    done < "$test_file"
}

@test "pdcdef_setup_create_variables_plugins: create variables for all plugins that exists a plugin.yml file" {
    # variables
    test_file="${TEMP}/test_file"

    # mocks
    pdcyml_path_plugins="${RESOURCES}/setup/plugins/some"
    pdcdef_create_variables() { echo "$1" >> "$test_file" ; }

    # run
    run pdcdef_setup_create_variables_plugins

    # asserts
    [ "$status" -eq 0 ]
    [ -f "$test_file" ]
    [ "$(cat $test_file)" != '' ]

    expected[0]="${pdcyml_path_plugins}/pdc-a-plugin/plugin.yml"
    expected[1]="${pdcyml_path_plugins}/pdc-c-plugin/plugin.yml"

    i=0
    while read line; do
        [ "${expected[$i]}" = "$line" ]
        [ "$i" -lt 2 ]
        i=$((i + 1))
    done < "$test_file"
}

# pdcdef_setup_create_variables_user -----------------------------------------
@test "pdcdef_setup_create_variables_user: must create variables" {
    # variables
    test_file="${TEMP}/test_file"

    # mocks
    pdcyml_path_root="${RESOURCES}/setup"
    pdcdef_create_variables() { echo "$1" > "$test_file" ; }

    # run
    run pdcdef_setup_create_variables_user

    # asserts
    [ "$status" -eq 0 ]
    [ -f "$test_file" ]
    [ "$(cat "$test_file")" = "${pdcyml_path_root}/pdc.yml" ]
}

@test "pdcdef_setup_create_variables_user: do not create variables when pdc.yml not found" {
    # variables
    test_file="${TEMP}/test_file"

    # mocks
    pdcyml_path_root="${TEMP}"
    pdcdef_create_variables() { echo "$1" > "$test_file" ; }

    # run
    run pdcdef_setup_create_variables_user

    # asserts
    [ "$status" -eq 1 ]
    [ ! -f "$test_file" ]
}

# pdcdef_setup_create_variables_additional -----------------------------------
@test "pdcdef_setup_create_variables_additional: create all variables from additionals yaml files" {
    # variables
    test_file="${TEMP}/test_file"

    # mocks
    pdcyml_yaml_files=( 'file1.yml' 'file2.yml' 'file3.yml' )
    pdcdef_create_variables() { echo "$1" >> "$test_file" ; }

    # run
    run pdcdef_setup_create_variables_additional

    # asserts
    [ "$status" -eq 0 ]
    [ -f "$test_file" ]
    [ "$(cat $test_file)" != '' ]

    expected[0]='file1.yml'
    expected[1]='file2.yml'
    expected[2]='file3.yml'

    i=0
    while read line; do
        [ "${expected[$i]}" = "$line" ]
        i=$((i + 1))
    done < "$test_file"
}

@test "pdcdef_setup_create_variables_additional: do not create variables" {
    # variables
    test_file="${TEMP}/test_file"

    # mocks
    pdcyml_yaml_files=( )
    pdcdef_create_variables() { touch "$test_file" ; }

    # run
    run pdcdef_setup_create_variables_additional

    # asserts
    [ "$status" -eq 0 ]
    [ ! -f "$test_file" ]
}

# pdcdef_setup_create_variables ----------------------------------------------
@test "pdcdef_setup_create_variables: test call functions" {
    # mocks
    pdcdef_setup_create_variables_default() { touch "${TEMP}/pdcdef_setup_create_variables_default"; }
    pdcdef_setup_create_variables_plugins() { touch "${TEMP}/pdcdef_setup_create_variables_plugins"; }
    pdcdef_setup_create_variables_user() { touch "${TEMP}/pdcdef_setup_create_variables_user"; }
    pdcdef_setup_create_variables_additional() { touch "${TEMP}/pdcdef_setup_create_variables_additional"; }

    # run
    run pdcdef_setup_create_variables

    # asserts
    [ "$status" -eq 0 ]
    [ -f "${TEMP}/pdcdef_setup_create_variables_default" ]
    [ -f "${TEMP}/pdcdef_setup_create_variables_plugins" ]
    [ -f "${TEMP}/pdcdef_setup_create_variables_user" ]
    [ -f "${TEMP}/pdcdef_setup_create_variables_additional" ]
}

@test "pdcdef_setup_create_variables: test functions order" {
    # variables
    i=1

    # mocks
    pdcdef_setup_create_variables_default() { echo "$i" > "${TEMP}/pdcdef_setup_create_variables_default" ; ((i+=1)) ; }
    pdcdef_setup_create_variables_plugins() { echo "$i" > "${TEMP}/pdcdef_setup_create_variables_plugins" ; ((i+=1)) ; }
    pdcdef_setup_create_variables_user() { echo "$i" > "${TEMP}/pdcdef_setup_create_variables_user" ; ((i+=1)) ; }
    pdcdef_setup_create_variables_additional() { echo "$i" > "${TEMP}/pdcdef_setup_create_variables_additional" ; ((i+=1)) ; }

    # run
    run pdcdef_setup_create_variables

    # asserts
    [ "$status" -eq 0 ]
    [ "$(cat ${TEMP}/pdcdef_setup_create_variables_default)" = '1' ]
    [ "$(cat ${TEMP}/pdcdef_setup_create_variables_plugins)"  = '2' ]
    [ "$(cat ${TEMP}/pdcdef_setup_create_variables_user)" = '3' ]
    [ "$(cat ${TEMP}/pdcdef_setup_create_variables_additional)" = '4' ]
}

# pdcdef_plugin_import -------------------------------------------------------
@test "pdcdef_plugin_import: import all files" {
    # variables
    test_file="${TEMP}/test_file"

    # mocks
    source() { echo "$1" >> "$test_file" ; }
    pdcyml_plugin_import=( 'file1' 'file2' 'file3' )

    # run
    run pdcdef_plugin_import

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

@test "pdcdef_plugin_import: test when import list is empty" {
    # variables
    test_file="${TEMP}/test_file"

    # mocks
    source() { touch "$test_file" ; }
    pdcyml_plugin_import=()

    # run
    run pdcdef_plugin_import

    # asserts
    [ "$status" -eq 0 ]
    [ ! -f "$test_file" ]
}

# pdcdef_plugin_setup --------------------------------------------------------
@test "pdcdef_plugin_setup: execute all plugins setup" {
    # variables
    test_file="${TEMP}/test_file"

    # mocks
    eval() { echo "$1" >> "$test_file" ; }
    pdcyml_plugin_setup=( 'cmd1' 'cmd2' 'cmd3' )

    # run
    run pdcdef_plugin_setup

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

@test "pdcdef_plugin_setup: test when setup list is empty" {
    # variables
    test_file="${TEMP}/test_file"

    # mocks
    eval() { touch "$test_file" ; }
    pdcyml_plugin_setup=()

    # run
    run pdcdef_plugin_setup

    # asserts
    [ "$status" -eq 0 ]
    [ ! -f "$test_file" ]
}

# pdcdef_imports -------------------------------------------------------------
@test "pdcdef_imports: must import one file" {
    # variables
    file1="${RESOURCES}/setup/sh/file1.sh"

    # mocks
    pdcyml_import=( "$file1" )

    # run
    run pdcdef_imports

    # asserts
    [ "$status" -eq 0 ]
    [ -f "${TEMP}/file1" ]
}

@test "pdcdef_imports: must import many files" {
    # variables
    file1="${RESOURCES}/setup/sh/file1.sh"
    file2="${RESOURCES}/setup/sh/file2.sh"
    file3="${RESOURCES}/setup/sh/file3.sh"

    # mocks
    pdcyml_import=( "$file1" "$file2" "$file3" )

    # run
    run pdcdef_imports

    # asserts
    [ "$status" -eq 0 ]
    [ -f "${TEMP}/file1" ]
    [ -f "${TEMP}/file2" ]
    [ -f "${TEMP}/file3" ]
}

@test "pdcdef_imports: must run without import any file" {
    # mocks
    pdcyml_import=( )

    # run
    run pdcdef_imports

    # asserts
    [ "$status" -eq 0 ]
}

# pdcdef_create_paths --------------------------------------------------------
@test "pdcdef_create_paths: test call functions and order" {
    # variables
    test_file="${TEMP}/test_file"

    # mocks
    pdcyml_path_root='first'
    pdcyml_path_log='second'
    pdcdef_create_if_not_exists() { echo "$1" >> "$test_file" ; }

    # run
    run pdcdef_create_paths

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

# pdcdef_create_if_not_exists ------------------------------------------------
@test "pdcdef_create_if_not_exists: create folder" {
    # variables
    path_="${TEMP}/folder"

    # run
    run pdcdef_create_if_not_exists "$path_"

    # asserts
    [ "$status" -eq 0 ]
    [ -d "$path_" ]
}

@test "pdcdef_create_if_not_exists: create recursive folder" {
    # variables
    path_="${TEMP}/folder/recursive"

    # run
    run pdcdef_create_if_not_exists "$path_"

    # asserts
    [ "$status" -eq 0 ]
    [ -d "$path_" ]
}

@test "pdcdef_create_if_not_exists: do not create folder when exists" {
    # variables
    path_="${TEMP}/folder"
    wrong="${TEMP}/wrong"
    mkdir "$path_"

    # mocks
    mkdir() { touch  ; }

    # run
    run pdcdef_create_if_not_exists "$path_"

    # asserts
    [ "$status" -eq 0 ]
    [ ! -d "$wrong" ]
}

# pdcdef_setup ---------------------------------------------------------------
@test "pdcdef_setup: test call functions" {
    # mocks
    pdcdef_lock_file() { touch "${TEMP}/pdcdef_lock_file"; }
    pdcdef_setup_create_variables() { touch "${TEMP}/pdcdef_setup_create_variables"; }
    pdcdef_plugin_import() { touch "${TEMP}/pdcdef_plugin_import"; }
    pdcdef_create_paths() { touch "${TEMP}/pdcdef_create_paths"; }
    pdcdef_plugin_setup() { touch "${TEMP}/pdcdef_plugin_setup"; }

    # run
    run pdcdef_setup

    # asserts
    [ "$status" -eq 0 ]
    [ -f "${TEMP}/pdcdef_lock_file" ]
    [ -f "${TEMP}/pdcdef_setup_create_variables" ]
    [ -f "${TEMP}/pdcdef_plugin_import" ]
    [ -f "${TEMP}/pdcdef_create_paths" ]
    [ -f "${TEMP}/pdcdef_plugin_setup" ]
}

@test "pdcdef_setup: test functions order" {
    # variables
    i=1

    # mocks
    pdcdef_lock_file() { echo "$i" > "${TEMP}/pdcdef_lock_file" ; ((i+=1)) ; }
    pdcdef_setup_create_variables() { echo "$i" > "${TEMP}/pdcdef_setup_create_variables" ; ((i+=1)) ; }
    pdcdef_plugin_import() { echo "$i" > "${TEMP}/pdcdef_plugin_import" ; ((i+=1)) ; }
    pdcdef_create_paths() { echo "$i" > "${TEMP}/pdcdef_create_paths" ; ((i+=1)) ; }
    pdcdef_plugin_setup() { echo "$i" > "${TEMP}/pdcdef_plugin_setup" ; ((i+=1)) ; }

    # run
    run pdcdef_setup

    # asserts
    [ "$status" -eq 0 ]
    [ "$(cat ${TEMP}/pdcdef_lock_file)" = '1' ]
    [ "$(cat ${TEMP}/pdcdef_setup_create_variables)"  = '2' ]
    [ "$(cat ${TEMP}/pdcdef_plugin_import)" = '3' ]
    [ "$(cat ${TEMP}/pdcdef_create_paths)" = '4' ]
    [ "$(cat ${TEMP}/pdcdef_plugin_setup)" = '5' ]
}
