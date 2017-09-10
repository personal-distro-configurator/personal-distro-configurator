#!/bin/bash
# shellcheck disable=SC2154

# Private function to output something and log it
# The log file is configured on *.yml file
#
# @arg1: message to log
#
function pdcdef_log() {
    local msg=$1
    echo "$msg" | tee -a "$pdcyml_settings_path_log/$pdcyml_settings_file_log"
}

# Public function to output something and log it
#
# @arg1: message to log
#
function log_info() {
    local msg=$1

    # Create log folder if not exists
    if [ ! -d "$pdcyml_settings_path_log" ]; then
        mkdir -p "$pdcyml_settings_path_log"
        log_info && log_info "Creating directory $pdcyml_settings_path_log"
    fi

    # Create log file if not exists
    if [ ! -f "$pdcyml_settings_path_log/$pdcyml_settings_file_log" ]; then
        touch "$pdcyml_settings_path_log/$pdcyml_settings_file_log"
    fi

    # write the log
    pdcdef_log "$msg"
}

# Public function to output something and log it
# Verbose mode
#
# @arg1: message to log
#
function log_verbose() {
    local msg=$1

    # if verbose are configured to true, log it
    if [[ "$pdcyml_settings_verbose" == "true" ]]; then
	   log_info "$msg"
    fi
}
