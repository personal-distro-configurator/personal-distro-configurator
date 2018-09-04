#!/usr/bin/env bash
# shellcheck disable=SC2154

_step_settings_plugins() {
    if [ -d "$pdcyml_path_plugins" ]; then
        for entry in "${pdcyml_path_plugins}"/*; do
            [ -d "$entry" ] &&
            [ "$(ls "$entry")" ] &&
            [ -f "${entry}/plugin.yml" ] &&
            pdcdef_yaml_createvariables "${entry}/plugin.yml"
        done
    fi

    return 0
}

_step_settings_user() {
    [ -f "${pdcyml_path_root}/pdc.yml" ] &&
    pdcdef_yaml_createvariables "${pdcyml_path_root}/pdc.yml"
}

read_settings() {
    _step_settings_plugins
    _step_settings_user
}
