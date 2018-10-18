#!/usr/bin/env bats

load ../../helper/test_helper

setup() {
    super_setup ".."
    source "${PDC_FOLDER}/sh/steps/_execute.sh"

}

teardown() {
    super_teardown
}

# execute.sh -----------------------------------------------------------------
@test "execute.sh: test function and command" {
    # mocks
    pdcyml_execute=( "shell touch "${TEMP}/shell"" )
    pdcyml_executors__command[0]="shell"
    pdcyml_executors__function[0]="shell_test"
    shell_test() { eval "$1" ; }
    log_info() { echo ; }

    # run
    execute

    # asserts
    [ -f "${TEMP}/shell" ]
}

@test "execute.sh: test many functions and commands" {
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
    execute

    # asserts
    [ -f "${TEMP}/shell" ]
    [ -f "${TEMP}/bash" ]
    [ -f "${TEMP}/sh" ]
}
