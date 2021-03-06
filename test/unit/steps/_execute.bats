#!/usr/bin/env bats

load ../../helper/test_helper

setup() {
    super_setup ".."
}

teardown() {
    super_teardown
}

# execute -------------------------------------------------------------
@test "execute: test function and command" {
    # variables

    # mocks
    pdcyml_execute=( "shell touch "${TEMP}/shell"" )
    pdcyml_executors__command[0]="shell"
    pdcyml_executors__function[0]="shell_test"
    shell_test() { eval "$1" ; }
    log_info() { echo ; }

    # run
    . "${PDC_FOLDER}/sh/steps/_execute.sh"

    # asserts
    [ -f "${TEMP}/shell" ]
}

@test "execute: test many functions and commands" {
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
    . "${PDC_FOLDER}/sh/steps/_execute.sh"

    # asserts
    [ -f "${TEMP}/shell" ]
    [ -f "${TEMP}/bash" ]
    [ -f "${TEMP}/sh" ]
}
