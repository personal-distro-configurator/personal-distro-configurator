#!/bin/bash

function pdcdef_log() {
    local msg=$1
    echo "$msg" | tee -a "$pdcyml_settings_path_log/$pdcyml_settings_file_log"
}

function log_info() {
    local msg=$1

    if [ ! -d "$pdcyml_settings_path_log" ]; then
        mkdir -p "$pdcyml_settings_path_log"
        log_info && log_info "Creating directory $pdcyml_settings_path_log"
    fi

    if [ ! -f "$pdcyml_settings_path_log/$pdcyml_settings_file_log" ]; then
        touch "$pdcyml_settings_path_log/$pdcyml_settings_file_log"
        # _log "Log file CREATED: $(date)"
    fi

    pdcdef_log "$msg"
}

function log_verbose() {
    local msg=$1

    if [[ "$pdcyml_settings_verbose" == "true" ]]; then
	   log_info "$msg"
    fi
}
