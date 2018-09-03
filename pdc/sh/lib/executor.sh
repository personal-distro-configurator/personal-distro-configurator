#!/usr/bin/env bash
# shellcheck disable=SC2154

pdcdef_executor_shell() {
    local cmd=$1
    eval "$cmd"
}

pdcdef_executor_sh() {
    local sh_file=$1
    eval "sh $sh_file"
}

pdcdef_executor_bash() {
    local bash_file=$1
    eval "bash $bash_file"
}

pdcdef_executor_plugin() {
    local plugin=$1

    local cmd

    cmd="$(pdcdef_yaml_loadsettings "${pdcyml_path_plugins}/pdc-${plugin}-plugin/plugin.yml" pdcyml_plugin_execute)"

    for c in "${cmd[@]}"; do
        eval "$(cut -d '=' -f2 <<< "$c" | sed 's/")$//' | sed 's/^("//' )"
    done
}
