#!/bin/bash

function pdcdef_get_plugins() {

    for i in ${!pdcyml_plugins_get[*]}; do
        local plugin=${pdcyml_plugins_get[i]}

        case $plugin in
            http://*) pdcdef_clone_plugin "$plugin" ;; # Git HTTP
            https://*) pdcdef_clone_plugin "$plugin" ;; # Git HTTPS
            git@*) pdcdef_clone_plugin "$plugin" ;; # Git SSH
            path::*) pdcdef_copy_plugin $( echo "$plugin" | sed 's/path:://' ) ;; # Directory Local
            tarbal::*) pdcdef_download_plugin $( echo "$plugin" | sed 's/tarbal:://' ) ;; # Tarbal Download
            *) pdcdef_clone_plugin "https://github.com/${plugin}.git" ;; # Github
        esac
    done
}

# Getting plugins via...
# ----------------------

function pdcdef_clone_plugin() {
    # Git Clone http and ssh
    local git_project_url=$1
    cd "$pdcyml_settings_path_plugins" && { log_verbose "Clone $git_project_url" && log_verbose; git clone "$git_project_url"; cd -; }
}

function pdcdef_download_plugin() {
    # Download compressed plugin (tarbal, zip, rar, etc)
    # TODO
    return
}

function pdcdef_copy_plugin() {
    # Copy plugin folder from some directory
    # TODO
    return
}
