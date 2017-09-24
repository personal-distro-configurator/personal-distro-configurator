#!/bin/bash
# shellcheck disable=SC2154

# ------------------------------------------------
# .CONFIRM STEP
#
# Output messages to confirm what will be executed
# There are two levels, info and verbose
# ------------------------------------------------

# Firsts messages to output
function pdcdef_confirm_header() {
    log_info && log_info "--------------------------------------- --"
    log_info && log_info "Personal Distro Configurator install at $(date)"

    log_info && log_info "The corresponding instalation will be done:"

    log_info
}

# Distribution informations, only what are configured
function pdcdef_confirm_distro() {
    [[ -n "${pdcyml_system_distro/[ ]*\n/}" ]] &&
    log_info "# Distro   : $pdcyml_system_distro"

    [[ -n "${pdcyml_system_version/[ ]*\n/}" ]] &&
    log_info "# Version  : $pdcyml_system_version"

    [[ -n "${pdcyml_system_arch/[ ]*\n/}" ]] &&
    log_info "# Arch     : $pdcyml_system_arch"

    [[ -n "${pdcyml_system_wm/[ ]*\n/}" ]] &&
    log_info "# WM       : $pdcyml_system_wm"

    log_info
}

# [VERBOSE] yaml files to be added
function pdcdef_confirm_yaml() {
    [ ! ${#pdcyml_yaml_files[@]} -eq 0 ] &&
    log_verbose "# YAML Settings to add (${#pdcyml_yaml_files[@]}):" &&
    log_verbose

    for yaml_file in ${pdcyml_yaml_files[*]}; do
        log_verbose "$yaml_file"
    done
}

# [VERBOSE] list of executions to run
function pdcdef_confirm_executions() {
    [ ! ${#pdcyml_execute[@]} -eq 0 ] &&
    log_verbose "# User execute lines to run: ${#pdcyml_execute[@]}" &&
    log_verbose

    return 0
}

# [VERBOSE] list of plugins to get
function pdcdef_confirm_plugins() {
    [ ! ${#pdcyml_plugins_get[@]} -eq 0 ] &&
    log_verbose "# Plugins add (${#pdcyml_plugins_get[@]}):" &&
    log_verbose

    for yaml_file in ${pdcyml_plugins_get[*]}; do
        log_verbose "$yaml_file"
    done
}

# Confirm step from plugins
function pdcdef_confirm_plugins_step() {
    for i in ${!pdcyml_plugins_steps_confirm[*]}; do
        eval "${pdcyml_plugins_steps_confirm[i]}"
    done
}

# Final, confirm it
function pdcdef_confirm_confirm() {
    # Confirm
    log_info "Confirm? [Y/n]" && read -r opt

    if [ "$opt" != 'Y' ] && [ "$opt" != 'y' ] && [ "$opt" != '' ]; then
        log_info && log_info "Canceled by user"
        exit 1
    fi
}

# Main
# ----

function pdcdef_confirm() {
    pdcdef_confirm_header
    pdcdef_confirm_distro
    pdcdef_confirm_yaml
    pdcdef_confirm_executions
    pdcdef_confirm_plugins
    pdcdef_confirm_plugins_step
    pdcdef_confirm_confirm
}
