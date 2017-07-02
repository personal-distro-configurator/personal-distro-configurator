#!/bin/bash

function _log() {
    local msg=$1
    echo "$msg" | tee -a "$settings_path_log/$settings_file_log"
}

function log_info() {
    local msg=$1

    if [ ! -d "$settings_path_log" ]; then
        mkdir -p "$settings_path_log"
        log_info && log_info "Creating directory $settings_path_log"
    fi

    if [ ! -f "$settings_path_log/$settings_file_log" ]; then
        touch "$settings_path_log/$settings_file_log"
        # _log "Log file CREATED: $(date)"
    fi

    _log "$msg"
}

function log_verbose() {
    local msg=$1

    if [[ "$settings_verbose" == "true" ]]; then
	   log_info "$msg"
    fi
}
