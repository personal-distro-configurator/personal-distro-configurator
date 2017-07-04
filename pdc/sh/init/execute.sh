#!/bin/bash

function pdc_execute() {
    # Update distro
    if [[ "$settings_update_distro" == "true" ]]; then
        log_info && log_info "Updating distro..." && log_info
        distro_update
        log_info && log_info "Distro updated!" && log_info
    fi

    # Install all distro dependencies
    if [[ "$settings_dependencies" != "" ]]; then
        log_info && log_info "Install dependencies..." && log_info
        distro_install_dependencies
        log_info && log_info "Dependencies installed with success!" && log_info
    fi

    log_info && log_info "Executions done!" && log_info
}
