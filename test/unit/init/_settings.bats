#!/usr/bin/env bats

load ../../helper/test_helper

setup() {
    super_setup ".."
    source "${PDC_FOLDER}/sh/init/_settings.sh"
}

teardown() {
    super_teardown
}

# _step_settings_plugins --------------------------------------
@test "_step_settings_plugins: create variable on one plugin" {
    # variables
    test_file="${TEMP}/test_file"

    # mocks
    pdcyml_path_plugins="${RESOURCES}/setup/plugins/one"
    pdcdef_yaml_createvariables() { echo "$1" > "$test_file" ; }

    # run
    run _step_settings_plugins

    # asserts
    [ "$status" -eq 0 ]
    [ "$(cat "$test_file")" = "${pdcyml_path_plugins}/pdc-a-plugin/plugin.yml" ]
}

@test "_step_settings_plugins: dont create variables when plugin.yml not found" {
    # variables
    test_file="${TEMP}/test_file"

    # mocks
    pdcyml_path_plugins="${RESOURCES}/setup/plugins/zero"
    pdcdef_yaml_createvariables() { echo "$1" > "$test_file" ; }

    # run
    run _step_settings_plugins

    # asserts
    [ "$status" -eq 0 ]
    [ ! -f "$test_file" ]
}

@test "_step_settings_plugins: dont create variables when no plugins found" {
    # variables
    test_file="${TEMP}/test_file"

    # mocks
    pdcyml_path_plugins="${RESOURCES}/setup/plugins/none"
    pdcdef_yaml_createvariables() { echo "$1" > "$test_file" ; }

    # run
    run _step_settings_plugins

    # asserts
    [ "$status" -eq 0 ]
    [ ! -f "$test_file" ]
}

@test "_step_settings_plugins: create variables for all plugins" {
    # variables
    test_file="${TEMP}/test_file"

    # mocks
    pdcyml_path_plugins="${RESOURCES}/setup/plugins/many"
    pdcdef_yaml_createvariables() { echo "$1" >> "$test_file" ; }

    # run
    run _step_settings_plugins

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

@test "_step_settings_plugins: create variables for all plugins that exists a plugin.yml file" {
    # variables
    test_file="${TEMP}/test_file"

    # mocks
    pdcyml_path_plugins="${RESOURCES}/setup/plugins/some"
    pdcdef_yaml_createvariables() { echo "$1" >> "$test_file" ; }

    # run
    run _step_settings_plugins

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

# _step_settings_user -----------------------------------------
@test "_step_settings_user: must create variables" {
    # variables
    test_file="${TEMP}/test_file"

    # mocks
    pdcyml_path_root="${RESOURCES}/setup"
    pdcdef_yaml_createvariables() { echo "$1" > "$test_file" ; }

    # run
    run _step_settings_user

    # asserts
    [ "$status" -eq 0 ]
    [ -f "$test_file" ]
    [ "$(cat "$test_file")" = "${pdcyml_path_root}/pdc.yml" ]
}

@test "_step_settings_user: do not create variables when pdc.yml not found" {
    # variables
    test_file="${TEMP}/test_file"

    # mocks
    pdcyml_path_root="${TEMP}"
    pdcdef_yaml_createvariables() { echo "$1" > "$test_file" ; }

    # run
    run _step_settings_user

    # asserts
    [ "$status" -eq 1 ]
    [ ! -f "$test_file" ]
}

# _step_settings_additional -----------------------------------
@test "_step_settings_additional: create all variables from additionals yaml files" {
    # variables
    test_file="${TEMP}/test_file"

    # mocks
    pdcyml_yaml=( 'file1.yml' 'file2.yml' 'file3.yml' )
    pdcdef_yaml_createvariables() { echo "$1" >> "$test_file" ; }

    # run
    run _step_settings_additional

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

@test "_step_settings_additional: do not create variables" {
    # variables
    test_file="${TEMP}/test_file"

    # mocks
    pdcyml_yaml=( )
    pdcdef_yaml_createvariables() { touch "$test_file" ; }

    # run
    run _step_settings_additional

    # asserts
    [ "$status" -eq 0 ]
    [ ! -f "$test_file" ]
}
