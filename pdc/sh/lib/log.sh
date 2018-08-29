#!/usr/bin/env bash
# shellcheck disable=SC2154

pdcdef_log_info() {
    _log() {
        local msg=$1
        echo "$msg" | tee -a "$pdcyml_path_log/$pdcyml_settings_file_log"
    }

    local msg=$1

    if [ ! -d "$pdcyml_path_log" ]; then
        mkdir -p "$pdcyml_path_log"
    fi

    if [ ! -f "$pdcyml_path_log/$pdcyml_settings_file_log" ]; then
        touch "$pdcyml_path_log/$pdcyml_settings_file_log"
    fi

    _log "$msg"
}

pdcdef_log_verbose() {
    local msg=$1

    if [[ "$pdcyml_settings_verbose" == "true" ]]; then
        pdcdef_log_info "$msg"
    fi
}
