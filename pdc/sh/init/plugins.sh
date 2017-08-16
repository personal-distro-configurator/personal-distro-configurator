#!/bin/bash

function pdc_get_plugins() {

    for i in ${!settings_plugins[*]}; do
        local plugin=${settings_plugins[i]}

        case $plugin in
            http://*) pdc_clone_plugin "$plugin" ;; # Git HTTP
            https://*) pdc_clone_plugin "$plugin" ;; # Git HTTPS
            git@*) pdc_clone_plugin "$plugin" ;; # Git SSH
            path::*) pdc_copy_plugin $( echo "$plugin" | sed 's/path:://' ) ;; # Directory Local
            tarbal::*) pdc_download_plugin $( echo "$plugin" | sed 's/tarbal:://' ) ;; # Tarbal Download
            *) pdc_clone_plugin "https://github.com/${plugin}.git" ;; # Github
        esac
    done
}

# Getting plugins via...
# ----------------------

function pdc_clone_plugin() {
    # Git Clone http and ssh
    local git_project_url=$1
    cd "$settings_path_plugins" && { git clone "$git_project_url"; cd -; }
}

function pdc_download_plugin() {
    # Download compressed plugin (tarbal, zip, rar, etc)
    # TODO
    return
}

function pdc_copy_plugin() {
    # Copy plugin folder from some directory
    # TODO
    return
}
