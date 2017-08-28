#!/bin/bash

function pdcdef_test_command() {
    local command=$1

    hash "$command" 2>/dev/null ||
    (
        log_info "Command ${command} not found. Abort installation? [y/N]" && read -r option

        if [[ $option == 'Y' ]] || [[ $option == 'y' ]] || [[ $option != '' ]]; then
            log_info "Canceled by user"
            exit 1
        fi
    )
}
