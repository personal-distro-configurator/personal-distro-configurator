#!/usr/bin/env bats

load ../helper/test_helper

setup() {
    super_setup
    source "${PDC_FOLDER}/sh/init/execute.sh"
}

teardown() {
    super_teardown
}

# pdcdef_execute_shell -------------------------------------------------------
@test "pdcdef_execute_shell: must run command" {
    RESULT=$(pdcdef_execute_shell 'echo 123')

    [ "$RESULT" == '123' ]
}

# pdcdef_execute_sh ----------------------------------------------------------
@test "pdcdef_execute_sh: must execute sh file" {
    TEMP_FILE="${RESOURCES}/execute/sh.sh"
    touch "$TEMP_FILE"

    RESULT=$(pdcdef_execute_sh "$TEMP_FILE")

    [ "$RESULT" == '456' ]
}

# pdcdef_execute_bash ----------------------------------------------------------
@test "pdcdef_execute_bash: must execute bash file" {
    TEMP_FILE="${RESOURCES}/execute/bash.sh"
    touch "$TEMP_FILE"

    RESULT=$(pdcdef_execute_bash "$TEMP_FILE")

    [ "$RESULT" == '789' ]
}

# pdcdef_execute_plugin ------------------------------------------------------
@test "pdcdef_execute_plugin: test values to execute" {
    # variables
    plugin="plugin"
    plugin_file="${TEMP}/plugin_result"
    plugin_command="(\"touch $plugin_file\")"

    # mocks
    pdcyml_path_plugins="${TEMP}"
    expected_plugin_path="${pdcyml_path_plugins}/pdc-${plugin}-plugin/plugin.yml"

    pdcdef_load_settings() {
        [ "$1" = "$expected_plugin_path" ] &&
        [ "$2" = 'pdcyml_plugins_steps_execute' ] &&
        settings="pdcyml_ok="$plugin_command"" &&
        echo "${settings[@]}" ;
    }

    # run
    pdcdef_execute_plugin "$plugin"

    # asserts
    [ -f "$plugin_file" ]
}

@test "pdcdef_execute_plugin: must execute many" {
    # variables
    plugin="plugin"

    # mocks
    source "${PDC_FOLDER}/sh/utils/yaml.sh"
    pdcyml_path_plugins="${RESOURCES}/execute"
    expected_plugin_path="${pdcyml_path_plugins}/pdc-${plugin}-plugin"
    expected_plugin_file="${expected_plugin_path}/plugin.yml"

    # run
    pdcdef_execute_plugin "$plugin"

    # asserts
    [ -f "${TEMP}/cmd1" ]
    [ -f "${TEMP}/cmd2" ]
    [ -f "${TEMP}/cmd3" ]
}

# pdcdef_execute -------------------------------------------------------------
@test "pdcdef_execute: test function and command" {
    # variables

    # mocks
    pdcyml_execute=( "shell touch "${TEMP}/shell"" )
    pdcyml_executors__command[0]="shell"
    pdcyml_executors__function[0]="shell_test"
    shell_test() { eval "$1" ; }
    log_info() { echo ; }

    # run
    pdcdef_execute

    # asserts
    [ -f "${TEMP}/shell" ]
}

@test "pdcdef_execute: test many functions and commands" {
    # variables
    command_test_file="${TEMP}/command"

    # mocks
    export pdcyml_execute
    pdcyml_execute+=( "bash touch "${TEMP}/bash"" )
    pdcyml_execute+=( "shell touch "${TEMP}/shell"" )
    pdcyml_execute+=( "sh touch "${TEMP}/sh"" )

    pdcyml_executors__command[0]="shell"
    pdcyml_executors__command[1]="sh"
    pdcyml_executors__command[2]="bash"

    pdcyml_executors__function[0]="shell_test"
    pdcyml_executors__function[1]="sh_test"
    pdcyml_executors__function[2]="bash_test"

    shell_test() { eval "$1" ; }
    sh_test() { eval "$1" ; }
    bash_test() { eval "$1" ; }
    log_info() { echo ; }

    # run
    pdcdef_execute

    # asserts
    [ -f "${TEMP}/shell" ]
    [ -f "${TEMP}/bash" ]
    [ -f "${TEMP}/sh" ]
}
