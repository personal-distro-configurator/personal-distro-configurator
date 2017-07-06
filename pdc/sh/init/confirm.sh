#!/bin/bash

function pdc_confirm() {
    log_info && log_info "--------------------------------------- --"
    log_info && log_info "Personal Distro Configurator install at $(date)"

    log_info && log_info "The corresponding instalation will be done:"

    log_info

    log_info "# Distro   : $settings_system_distro"
    log_info "# Version  : $settings_system_version"
    log_info "# Arch     : $settings_system_arch"
    log_info "# WM       : $settings_system_wm"

    log_info

    if [[ "$settings_update_distro" == "true" ]]; then
        log_info "# Distro will be updated" && log_info
    fi

    if [[ "$settings_dependencies" != "" ]]; then
        log_info "# Dependencies: ${settings_dependencies[*]}" && log_info
    fi

    if [[ "$settings_pip" != "" ]]; then
        log_info "# PIP: ${settings_pip[*]}" && log_info
    fi

    if [[ "$settings_gem" != "" ]]; then
        log_info "# GEM: ${settings_gem[*]}" && log_info
    fi

    if [[ "$settings_npm" != "" ]]; then
        log_info "# NPM: ${settings_npm[*]}" && log_info
    fi

    log_info "Confirm? [Y/n]" && read -r option

    if [[ $option != 'Y' && $option != 'y' && $option != '' ]]; then
        log_info && log_info "Canceled by user"
        exit 1
    fi
}
