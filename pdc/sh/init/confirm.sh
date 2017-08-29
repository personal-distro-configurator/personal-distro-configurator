#!/bin/bash

function pdcdef_confirm() {
    # Header
    log_info && log_info "--------------------------------------- --"
    log_info && log_info "Personal Distro Configurator install at $(date)"

    log_info && log_info "The corresponding instalation will be done:"

    log_info

    # Distro Info
    [[ -n "${pdcyml_system_distro/[ ]*\n/}" ]] &&
    log_info "# Distro   : $pdcyml_system_distro"

    [[ -n "${pdcyml_system_version/[ ]*\n/}" ]] &&
    log_info "# Version  : $pdcyml_system_version"

    [[ -n "${pdcyml_system_arch/[ ]*\n/}" ]] &&
    log_info "# Arch     : $pdcyml_system_arch"

    [[ -n "${pdcyml_system_wm/[ ]*\n/}" ]] &&
    log_info "# WM       : $pdcyml_system_wm"

    log_info

    # YAML Files
    [ ! ${#pdcyml_yaml_files[@]} -eq 0 ] &&
    log_info "# YAML Settings to add (${#pdcyml_yaml_files[@]}):" && log_info

    for yaml_file in $pdcyml_yaml_files; do
        log_info "$yaml_file"
    done

    # Executions
    [ ! ${#pdcyml_execute[@]} -eq 0 ] &&
    log_verbose "# User execute lines to run: ${#pdcyml_execute[@]}" && log_verbose

    # Plugins
    [ ! ${#pdcyml_plugins_get[@]} -eq 0 ] &&
    log_verbose "# Plugins add (${#pdcyml_plugins_get[@]}):" && log_verbose

    for yaml_file in $pdcyml_plugins_get; do
        log_verbose "$yaml_file"
    done

    # Plugins Step
    for i in ${!pdcyml_plugins_steps_confirm[*]}; do
        eval ${pdcyml_plugins_steps_confirm[i]}
    done

    # Confirm
    log_info "Confirm? [Y/n]" && read -r option

    if [[ $option != 'Y' && $option != 'y' && $option != '' ]]; then
        log_info && log_info "Canceled by user"
        exit 1
    fi
}
