#!/bin/bash

function pdc_setup() {
    printf "Setup installer...\n"

    pdc_lock_file
    pdc_setup_create_variables
    pdc_plugin_import
    pdc_create_paths
    pdc_plugin_setup

    printf "Setup done!\n"
}

function pdc_plugin_setup() {
    for i in ${!settings_plugin_steps_setup[*]}; do
        eval ${settings_plugin_steps_setup[i]}
    done
}

function pdc_plugin_import() {
    for i in ${!settings_plugin_steps_import[*]}; do
        source ${settings_plugin_steps_import[i]}
    done
}

function pdc_setup_create_variables() {
    # Default .yml
    pdc_create_variables "settings.yml"

    # User .yml
    [ -f "${settings_path_install}/pdc.yml" ] && pdc_create_variables "${settings_path_install}/pdc.yml"

    # Plugins .yml
    [ -d "${settings_path_plugins}" ] &&
    for entry in ${settings_path_plugins}/*; do

        [ -d "$entry" ] && [ "$(ls "$entry")" ] &&
        for e in $entry/*; do
            [ -f "${e}/plugin.yml" ] && pdc_create_variables "${e}/plugin.yml"
        done
    done

    # Additional .yml
    for yaml_file in $settings_yaml_files; do
        log_verbose "Add ${yaml_file} settings file" && log_verbose
        pdc_create_variables "$yaml_file"
    done
}

function pdc_create_paths() {
    _create_if_not_exists "$settings_path_install"
    _create_if_not_exists "$settings_path_log"
}

function _create_if_not_exists() {
    local path_=$1

    if [ ! -d "$path_" ]; then
        log_info && log_info "Creating directory $path_" && log_info
        mkdir -p "$path_"
    fi
}
