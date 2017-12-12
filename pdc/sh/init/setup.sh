#!/bin/bash
# shellcheck disable=SC2154
# shellcheck disable=SC1090

# ------------------------------------------------
# .SETUP STEP
#
# Configure the things before it is executed.
# All variables from *.yml files are created here,
# with any plugin setup needed too.
# ------------------------------------------------

# Create variables
# ----------------

# Read and create variables from default settings.yml file
function pdcdef_setup_create_variables_default() {
    pdcdef_create_variables "settings.yml"
}

# Read and create variables from plugin.yml files,
# found on root of every plugin folder
function pdcdef_setup_create_variables_plugins() {
    if [ -d "$pdcyml_path_plugins" ]; then
        for entry in $pdcyml_path_plugins/*; do
            [ -d "$entry" ] &&
            [ "$(ls "$entry")" ] &&
            [ -f "${entry}/plugin.yml" ] &&
            pdcdef_create_variables "${entry}/plugin.yml"
        done
    fi

    return 0
}

# Read and create variables from pdc.yml user file
function pdcdef_setup_create_variables_user() {
    [ -f "${pdcyml_path_root}/pdc.yml" ] &&
    pdcdef_create_variables "${pdcyml_path_root}/pdc.yml"
}

# All *.yml files can informe additionals *.yml files to be read
# Here these files will be read and created variables
function pdcdef_setup_create_variables_additional() {
    for yaml_file in ${pdcyml_yaml[*]}; do
        log_verbose "Add ${yaml_file} settings file" && log_verbose
        pdcdef_create_variables "$yaml_file"
    done

    return 0
}

# Call each function to create variables from *.yml files
function pdcdef_setup_create_variables() {
    pdcdef_setup_create_variables_default
    pdcdef_setup_create_variables_plugins
    pdcdef_setup_create_variables_user
    pdcdef_setup_create_variables_additional
}

# Plugins Steps
# -------------

# Plugin import step, from import list
function pdcdef_plugin_import() {
    for i in ${!pdcyml_plugin_import[*]}; do
        source "${pdcyml_plugin_import[i]}"
    done
}

# Plugin setup step, from setup list
function pdcdef_plugin_setup() {
    for i in ${!pdcyml_plugin_setup[*]}; do
        eval "${pdcyml_plugin_setup[i]}"
    done
}

# Imports
# -------

function pdcdef_imports() {
    for imp in "${pdcyml_import[@]}"; do
        source "$imp"
    done
}

# Setup Configs
# -------------

# Create paths from configs
function pdcdef_create_paths() {
    pdcdef_create_if_not_exists "$pdcyml_path_root"
    pdcdef_create_if_not_exists "$pdcyml_path_log"
}

# Valid and create folder, if not exists
#
# @arg1: path to folder
#
function pdcdef_create_if_not_exists() {
    local path_=$1

    if [ ! -d "$path_" ]; then
        log_info && log_info "Creating directory $path_" && log_info
        mkdir -p "$path_"
    fi
}

# Main
# ----

function pdcdef_setup() {
    printf "Setup installer...\n"

    pdcdef_lock_file

    pdcdef_setup_create_variables
    pdcdef_plugin_import
    pdcdef_create_paths
    pdcdef_plugin_setup

    printf "Setup done!\n"
}
