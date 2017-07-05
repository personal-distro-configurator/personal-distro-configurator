#!/bin/bash

function pdc_test_command() {
    local command=$1
    hash "${command}" 2>/dev/null
}

function pdc_command_not_found() {
    local command=$1

    log_info "Command ${command} not found. Abort installation? [y/N]" && read -r option

    if [[ $option != 'Y' && $option != 'y' && $option != '' ]]; then
        log_info && log_info "Canceled by user"
        exit 1
    fi
}
