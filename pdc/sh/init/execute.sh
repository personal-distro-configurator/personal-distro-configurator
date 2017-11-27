#!/bin/bash
# shellcheck disable=SC2154

# ----------------------------------------------------------
# .EXECUTE STEP
#
# Execute all commands from execute list, based on
# executors pre-configured on *.yml files.
#
# Executors can be added from plugins or user configuration.
# ----------------------------------------------------------

# Executors
# ---------

# Run a specific command
#
# @arg1: execute command
#
function pdcdef_execute_shell() {
    local cmd=$1
    eval "$cmd"
}

# Run a sh file, if it as arguments, is informed too
#
# @arg1: execute command
#
function pdcdef_execute_sh() {
    local sh_file=$1
    eval "sh $sh_file"
}

# Run a bash file, if it as arguments, is informed too
#
# @arg1: execute command
#
function pdcdef_execute_bash() {
    local bash_file=$1
    eval "bash $bash_file"
}

# Run execute list from a plugin
#
# @arg1: execute command
#
function pdcdef_execute_plugin() {
    local plugin=$1

    local cmd

    cmd="$(pdcdef_load_settings "${pdcyml_settings_path_plugins}/pdc-${plugin}-plugin/plugin.yml" pdcyml_plugins_steps_execute)"

    for c in "${cmd[@]}"; do
        eval "$(cut -d '=' -f2 <<< "$c" | sed 's/")$//' | sed 's/^("//' )"
    done
}

# Main
# ----

function pdcdef_execute() {
    # Start
    log_info "Starting executions..." && log_info

    # Run every execute command
    for execution in "${pdcyml_execute[@]}"; do

        # Find executor for execute command
        for i in ${!pdcyml_settings_executors__command[*]}; do

            # test if executor is what was informed
            if [ "${pdcyml_settings_executors__command[$i]}" = "$(cut -d ' ' -f1 <<< "$execution")" ]; then

                # if is, call function for this command,
                # passing all arguments informed
                "${pdcyml_settings_executors__function[$i]}" "${execution#${pdcyml_settings_executors__command[$i]} }"
            fi
        done
    done

    # Done
    log_info "Executions done!" && log_info
}
