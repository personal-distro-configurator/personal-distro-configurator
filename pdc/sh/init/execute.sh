#!/bin/bash

function pdcdef_execute() {

    # Pre-Execute Plugins
    log_info "Running pre-execute plugins..." && log_info
    for i in ${!pdcyml_plugins_pre_execute[*]}; do
        eval ${pdcyml_plugins_pre_execute[i]}
    done
    log_info && log_info "Pre-execute plugins done!" && log_info

    # Plugins
    log_info "Running plugins execute step..." && log_info
    for i in ${!pdcyml_plugins_steps_execute[*]}; do
        eval ${pdcyml_plugins_steps_execute[i]}
    done
    log_info && log_info "Plugins executions done!" && log_info

    # User Executions
    log_info "Running user executions..." && log_info
    for i in ${!pdcyml_execute[*]}; do
        eval ${pdcyml_execute[i]}
    done
    log_info && log_info "User executions done!" && log_info

    # Done
    log_info "Executions done!" && log_info
}
