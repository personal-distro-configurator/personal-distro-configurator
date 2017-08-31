#!/bin/bash

function pdcdef_setup() {
    printf "Setup installer...\n"

    pdcdef_lock_file
    pdcdef_setup_create_variables
    pdcdef_plugin_import
    pdcdef_create_paths
    pdcdef_plugin_setup

    printf "Setup done!\n"
}

function pdcdef_plugin_setup() {
    for i in ${!pdcyml_plugins_steps_setup[*]}; do
        eval ${pdcyml_plugins_steps_setup[i]}
    done
}

function pdcdef_plugin_import() {
    for i in ${!pdcyml_plugins_steps_import[*]}; do
        source ${pdcyml_plugins_steps_import[i]}
    done
}

function pdcdef_setup_create_variables() {
    # Default .yml
    pdcdef_create_variables "settings.yml"

    # Plugins .yml
    if [ -d "${pdcyml_settings_path_plugins}" ]; then
        for entry in ${pdcyml_settings_path_plugins}/*; do
            [ -d "$entry" ] &&
            [ "$(ls "$entry")" ] &&
            [ -f "${entry}/plugin.yml" ] &&
            pdcdef_create_variables "${entry}/plugin.yml"
        done
    fi

    # User .yml
    [ -f "${pdcyml_settings_path_install}/pdc.yml" ] && pdcdef_create_variables "${pdcyml_settings_path_install}/pdc.yml"

    # Additional .yml
    for yaml_file in $pdcyml_yaml_files; do
        log_verbose "Add ${yaml_file} settings file" && log_verbose
        pdcdef_create_variables "$yaml_file"
    done
}

function pdcdef_create_paths() {
    pdcdef_create_if_not_exists "$pdcyml_settings_path_install"
    pdcdef_create_if_not_exists "$pdcyml_settings_path_log"
}

function pdcdef_create_if_not_exists() {
    local path_=$1

    if [ ! -d "$path_" ]; then
        log_info && log_info "Creating directory $path_" && log_info
        mkdir -p "$path_"
    fi
}
