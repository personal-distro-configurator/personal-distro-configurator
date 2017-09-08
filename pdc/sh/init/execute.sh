#!/bin/bash

function pdcdef_execute() {

    # Start
    log_info "Starting executions..." && log_info

    # Run every execute command
    for execution in "${pdcyml_execute[@]}"; do
        # Find executor for execute command
        for i in ${!pdcyml_settings_executors__command[*]}; do
            # test if executor is what was informed
            [ "${pdcyml_settings_executors__command[$i]}" = "$(echo $execution | cut -d ' ' -f1)" ] &&
            # if is, call function for this command, passing all arguments informed
            "${pdcyml_settings_executors__function[$i]}" "${execution#${pdcyml_settings_executors__command[$i]} }"
        done
    done

    # Done
    log_info "Executions done!" && log_info
}

# ---------
# Executors
# ---------

# Run a specific command
function pdcdef_execute_shell() {
    local cmd=$1
    eval "$cmd"
}

# Run a sh file, if it as arguments, is informed too
function pdcdef_execute_sh() {
    local sh_file=$1
    sh "$sh_file"
}

# Run a bash file, if it as arguments, is informed too
function pdcdef_execute_bash() {
    local bash_file=$1
    bash "$bash_file"
}

# Run execute list from a plugin
function pdcdef_execute_plugin() {
    local plugin=$1

    local cmd

    cmd="$(pdcdef_load_settings "${pdcyml_settings_path_plugins}/pdc-${plugin}-plugin/plugin.yml" pdcyml_plugins_steps_execute)"

    for c in ${cmd[*]}; do
        eval "$(echo "$c" | cut -d '=' -f2)"
    done
}
