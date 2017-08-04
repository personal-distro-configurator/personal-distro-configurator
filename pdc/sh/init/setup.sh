#!/bin/bash

function pdc_setup() {
    printf "Setup installer...\n"

    pdc_lock_file

    pdc_create_variables "settings.yml"

    for yaml_file in $settings_yaml_files; do
        log_verbose "Add ${yaml_file} settings file" && log_verbose
        pdc_create_variables "$yaml_file"
    done

    [ -f "../pdc.yml" ] && pdc_create_variables "../pdc.yml"

    _create_if_not_exists "$settings_path_install"
    _create_if_not_exists "$settings_path_log"

    printf "Setup done!\n"
}

function _create_if_not_exists() {
    local path_=$1

    if [ ! -d "$path_" ]; then
        log_info && log_info "Creating directory $path_" && log_info
        mkdir -p "$path_"
    fi
}
