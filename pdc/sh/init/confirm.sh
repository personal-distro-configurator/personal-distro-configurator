#!/bin/bash

function pdc_confirm() {
    # Header
    log_info && log_info "--------------------------------------- --"
    log_info && log_info "Personal Distro Configurator install at $(date)"

    log_info && log_info "The corresponding instalation will be done:"

    log_info

    # Distro Info
    [[ -n "${settings_system_distro/[ ]*\n/}" ]] &&
    log_info "# Distro   : $settings_system_distro"

    [[ -n "${settings_system_version/[ ]*\n/}" ]] &&
    log_info "# Version  : $settings_system_version"

    [[ -n "${settings_system_arch/[ ]*\n/}" ]] &&
    log_info "# Arch     : $settings_system_arch"

    [[ -n "${settings_system_wm/[ ]*\n/}" ]] &&
    log_info "# WM       : $settings_system_wm"

    log_info

    # YAML Files
    [ ! ${#settings_yaml_files[@]} -eq 0 ] &&
    log_info "# YAML Settings to add (${#settings_yaml_files[@]}):" && log_info

    for yaml_file in $settings_yaml_files; do
        log_info "$yaml_file"
    done

    # Executions
    [ ! ${#settings_execute[@]} -eq 0 ] &&
    log_verbose "# User execute lines to run: ${#settings_execute[@]}" && log_verbose

    # Plugins
    [ ! ${#settings_plugins[@]} -eq 0 ] &&
    log_verbose "# Plugins add (${#settings_plugins[@]}):" && log_verbose

    for yaml_file in $settings_plugins; do
        log_verbose "$yaml_file"
    done

    # Plugins Step
    for i in ${!settings_plugin_steps_confirm[*]}; do
        eval ${settings_plugin_steps_confirm[i]}
    done

    ## TODO: Move to plugin {
    # Repository
    #[[ "$settings_update_distro" == "true" ]] && log_info "# Distro will be updated" && log_info
    #[[ "$settings_dependencies" != "" ]] && log_info "# Dependencies: ${settings_dependencies[*]}" && log_info

    # Installs
    #[[ "$settings_pip" != "" ]] && log_info "# PIP: ${settings_pip[*]}" && log_info
    #[[ "$settings_gem" != "" ]] && log_info "# GEM: ${settings_gem[*]}" && log_info
    #[[ "$settings_npm" != "" ]] && log_info "# NPM: ${settings_npm[*]}" && log_info
    ## --}

    # Confirm
    log_info "Confirm? [Y/n]" && read -r option

    if [[ $option != 'Y' && $option != 'y' && $option != '' ]]; then
        log_info && log_info "Canceled by user"
        exit 1
    fi
}
