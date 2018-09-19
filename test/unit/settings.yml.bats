#!/usr/bin/env bats

load ../helper/test_helper

setup() {
    super_setup "."
}

teardown() {
    super_teardown
}

# settings.yml ---------------------------------------------------------------
@test "settings.yml: validate values" {
    # mock
    PDCCONST_RUNNING_DIR="/pdc"

    # run
    source "${PDC_FOLDER}/sh/lib/yaml.sh"
    pdcdef_yaml_createvariables "${PDC_FOLDER}/settings.yml"

    # asserts
    [ -n "${pdcyml_settings_yaml_exclude// /}" ]
    [ -n "${pdcyml_settings_file_log// /}" ]
    [ -n "${pdcyml_path_root// /}" ]
    [ -n "${pdcyml_path_log// /}" ]
    [ -n "${pdcyml_path_tmp// /}" ]
    [ -n "${pdcyml_path_resources// /}" ]
    [ -n "${pdcyml_path_scripts// /}" ]
    [ -n "${pdcyml_path_plugins// /}" ]
}

@test "settings.yml: validate executors" {
    # run
    source "${PDC_FOLDER}/sh/lib/yaml.sh"
    pdcdef_yaml_createvariables "${PDC_FOLDER}/settings.yml"

    # asserts
    [ -n "${pdcyml_executors__command[*]}" ]
    [ -n "$(echo "${pdcyml_executors__command[*]}" | grep 'sh')" ]
    [ -n "$(echo "${pdcyml_executors__command[*]}" | grep 'shell')" ]
    [ -n "$(echo "${pdcyml_executors__command[*]}" | grep 'bash')" ]
    [ -n "$(echo "${pdcyml_executors__command[*]}" | grep 'plugin')" ]

    [ -n "${pdcyml_executors__function[*]}" ]
    [ -n "$(echo "${pdcyml_executors__function[*]}" | grep 'pdcdef_executor_sh')" ]
    [ -n "$(echo "${pdcyml_executors__function[*]}" | grep 'pdcdef_executor_shell')" ]
    [ -n "$(echo "${pdcyml_executors__function[*]}" | grep 'pdcdef_executor_bash')" ]
    [ -n "$(echo "${pdcyml_executors__function[*]}" | grep 'pdcdef_executor_plugin')" ]
}

@test "settings.yml: validate executors functions exists" {
    # run
    source "${PDC_FOLDER}/sh/lib/executor.sh"

    # asserts
    [ -n "$(declare -F | awk '{print $3}' | grep 'pdcdef_executor_sh')" ]
    [ -n "$(declare -F | awk '{print $3}' | grep 'pdcdef_executor_shell')" ]
    [ -n "$(declare -F | awk '{print $3}' | grep 'pdcdef_executor_bash')" ]
    [ -n "$(declare -F | awk '{print $3}' | grep 'pdcdef_executor_plugin')" ]
}
