#!/usr/bin/env bash
# shellcheck disable=SC2154

_clone_plugin() {
    local git_project_url=$1
    local ibranch=$2
    local branch=""
    local gitclone=""
    local plugin

    plugin=$(sed -e 's|.*/||g;s|.git||g' <<< "$git_project_url")
    branch=$([[ -n "${ibranch/[ ]*\n/}" ]] && echo "--branch $ibranch" || echo "")
    gitclone="git clone ${git_project_url} ${branch} --depth 1"

    [ -d "${pdcyml_path_plugins}/${plugin}" ] && return;
    (cd "$pdcyml_path_plugins" && $gitclone && echo)
}

# Download compressed plugin (tarbal, zip, rar, etc)
_download_plugin() {
    return # TODO
}

# Copy plugin folder from some directory
_copy_plugin() {
    return # TODO
}

get_plugins() {
    local pdcyml_plugins

    pdcdef_yaml_loadsettings "${pdcyml_path_root}/pdc.yml" pdcyml_plugins

    for plugin in "${pdcyml_plugins[@]}"; do

        case $plugin in

            # Git HTTP Clone
            http://*)
                _clone_plugin "http:$(cut -d ':' -f2 <<< "$plugin")" "$(cut -d ':' -f3 <<< "$plugin")"
            ;;

            # Git HTTPS Clone
            https://*)
                _clone_plugin "https:$(cut -d ':' -f2 <<< "$plugin")" "$(cut -d ':' -f3 <<< "$plugin")"
            ;;

            # Git SSH Clone
            git@*)
                _clone_plugin "$plugin"
            ;;

            # Copy plugin from folder
            path::*)
                _copy_plugin "$(sed 's/path:://' <<< "$plugin")"
            ;;

            # Download plugin as tarball
            tarbal::*)
                _download_plugin "$(sed 's/tarbal:://' <<< "$plugin")"
            ;;

            # GitHub Plugin Clone
            *)
                [[ "$plugin" != "" ]] || continue
                _clone_plugin "https://github.com/$(cut -d ':' -f1 <<< "$plugin").git" "$([ -z "${plugin##*:*}" ] && cut -d ':' -f2 <<< "$plugin")"
            ;;
        esac
    done
}
