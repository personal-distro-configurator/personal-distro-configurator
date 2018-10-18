#!/usr/bin/env bash
# shellcheck disable=SC2154

pdcdef_executor_shell() {
    local cmd=$1
    (eval "$cmd")
}

pdcdef_executor_sh() {
    local sh_file=$1
    (eval "sh $sh_file")
}

pdcdef_executor_bash() {
    local bash_file=$1
    (eval "bash $bash_file")
}

pdcdef_executor_plugin() {
    local plugin=$1
    local pdcyml_plugin_execute

    pdcdef_yaml_loadsettings "${pdcyml_path_plugins}/${plugin}/plugin.yml" pdcyml_plugin_execute

    for c in "${pdcyml_plugin_execute[@]}"; do
        (eval "$c")
    done
}
