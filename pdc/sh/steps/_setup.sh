#!/usr/bin/env bash
# shellcheck disable=SC2154

_step_setup_plugin() {
    for i in ${!pdcyml_plugin_setup[*]}; do
        eval "${pdcyml_plugin_setup[i]}"
    done
}

setup() {
    _step_setup_plugin
}
