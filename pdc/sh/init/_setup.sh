#!/usr/bin/env bash
# shellcheck disable=SC2154

_create_if_not_exists() {
    local path_=$1

    if [ ! -d "$path_" ]; then
        mkdir -p "$path_"
    fi
}

create_variables() {
    pdcdef_yaml_createvariables "settings.yml"
}

create_paths() {
    _create_if_not_exists "$pdcyml_path_root"
    _create_if_not_exists "$pdcyml_path_log"
}
