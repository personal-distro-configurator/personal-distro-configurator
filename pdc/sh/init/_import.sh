#!/usr/bin/env bash
# shellcheck disable=SC2154
# shellcheck disable=SC1090

_plugin_import() {
    for file in "${pdcyml_plugin_import[@]}"; do
        source "$file"
    done
}

_user_import() {
    for imp in "${pdcyml_import[@]}"; do
        source "$imp"
    done
}

import_shell_files() {
    _plugin_import
    _user_import
}
