#!/usr/bin/env bash
# shellcheck disable=SC2154

_step_setup_plugin() {
    for plugin_setup in "${pdcyml_plugin_setup[@]}"; do
        eval "$plugin_setup"
    done
}

setup() {
    _step_setup_plugin
}
