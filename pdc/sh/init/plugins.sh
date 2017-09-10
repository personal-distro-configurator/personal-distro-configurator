#!/bin/bash
# shellcheck disable=SC2154

# -------------------------------------------------------------
# .PLUGIN STEP
#
# Save plugins to plugins folder, getting from git or other way
# -------------------------------------------------------------

# Getting plugins via...
# ----------------------

# Git Clone plugin, only Head
#
# @arg1: git url
# @arg2: (optional) branch or tag to clone
#
function pdcdef_clone_plugin() {
    local git_project_url=$1
    local branch=""
    local cmd="git clone ${git_project_url} ${branch} --depth 1"

    # if branch is informed in arg2, set to clone it
    branch=$([[ -n "${pdcyml_system_wm/[ ]*\n/}" ]] && echo "--branch $2")

    cd "$pdcyml_settings_path_plugins" && $cmd; cd - || exit 1;
}

# Download compressed plugin (tarbal, zip, rar, etc)
function pdcdef_download_plugin() {
    return # TODO
}

# Copy plugin folder from some directory
function pdcdef_copy_plugin() {
    return # TODO
}

# Main
# ----

function pdcdef_get_plugins() {
    for i in ${!pdcyml_plugins_get[*]}; do
        local plugin=${pdcyml_plugins_get[i]}

        case $plugin in

            # Git HTTP Clone
            http://*)
                pdcdef_clone_plugin "$(cut -d ':' -f1 <<< "$plugin")" "$(cut -d ':' -f2 <<< "$plugin")"
            ;;

            # Git HTTPS Clone
            https://*)
                pdcdef_clone_plugin "$(cut -d ':' -f1 <<< "$plugin")" "$(cut -d ':' -f2 <<< "$plugin")"
            ;;

            # Git SSH Clone
            git@*)
                pdcdef_clone_plugin "$plugin"
            ;;

            # Copy plugin from folder
            path::*)
                pdcdef_copy_plugin "$(sed 's/path:://' <<< "$plugin")"
            ;;

            # Download plugin as tarball
            tarbal::*)
                pdcdef_download_plugin "$(sed 's/tarbal:://' <<< "$plugin")"
            ;;

            # GitHub Plugin Clone
            *)
                pdcdef_clone_plugin "https://github.com/$(cut -d ':' -f1 <<< "$plugin").git" "$(cut -d ':' -f2 <<< "$plugin")"
            ;;
        esac
    done
}
