#!/usr/bin/env bats

load ../helper/test_helper

setup() {
    super_setup
    source "${PDC_FOLDER}/sh/init/plugins.sh"

    export git_file="${TEMP}/gitlog"
}

teardown() {
    super_teardown
}

# pdcdef_clone_plugin --------------------------------------------------------
@test "pdcdef_clone_plugin: clone plugin via git, using branch" {
    # variables
    git_url='https://github.com/user/project.git'
    git_branch='develop'

    # mocks
    git() { touch "$git_file" && echo "git $@" >> "$git_file"; }
    pdcyml_path_plugins="${TEMP}"

    # run
    run pdcdef_clone_plugin "$git_url" "$git_branch"

    # asserts
    [ "$status" -eq 0 ]
    [ "$(cat $git_file)" = "git clone $git_url --branch $git_branch --depth 1" ]
}

@test "pdcdef_clone_plugin: clone plugin via git, not using branch" {
    # variables
    git_url='https://github.com/user/project.git'

    # mocks
    git() { touch "$git_file" && echo "git $@" >> "$git_file"; }
    pdcyml_path_plugins="${TEMP}"

    # run
    run pdcdef_clone_plugin "$git_url"

    # asserts
    [ "$status" -eq 0 ]
    [ "$(cat $git_file)" = "git clone $git_url --depth 1" ]
}

# pdcdef_get_plugins ---------------------------------------------------------
@test "pdcdef_get_plugins: http git clone" {
    # variables
    url='http://git.com/user/project.git'

    # mocks
    pdcyml_plugins_get=( "$url" )
    pdcdef_clone_plugin() { touch "$git_file" && echo "$@" >> "$git_file"; }

    # run
    run pdcdef_get_plugins

    # asserts
    [ "$status" -eq 0 ]
    [ "$(cat $git_file)" = "$url " ]
}

@test "pdcdef_get_plugins: http git clone, using branch" {
    # variables
    url='http://git.com/user/project.git'
    branch='develop'

    # mocks
    pdcyml_plugins_get=( "${url}:${branch}" )
    pdcdef_clone_plugin() { touch "$git_file" && echo "$@" >> "$git_file"; }

    # run
    run pdcdef_get_plugins

    # asserts
    [ "$status" -eq 0 ]
    [ "$(cat $git_file)" = "$url $branch" ]
}

@test "pdcdef_get_plugins: https git clone" {
    # variables
    url='https://git.com/user/project.git'

    # mocks
    pdcyml_plugins_get=( "$url" )
    pdcdef_clone_plugin() { touch "$git_file" && echo "$@" >> "$git_file"; }

    # run
    run pdcdef_get_plugins

    # asserts
    [ "$status" -eq 0 ]
    [ "$(cat $git_file)" = "$url " ]
}

@test "pdcdef_get_plugins: https git clone, using branch" {
    # variables
    url='https://git.com/user/project.git'
    branch='develop'

    # mocks
    pdcyml_plugins_get=( "${url}:${branch}" )
    pdcdef_clone_plugin() { touch "$git_file" && echo "$@" >> "$git_file"; }

    # run
    run pdcdef_get_plugins

    # asserts
    [ "$status" -eq 0 ]
    [ "$(cat $git_file)" = "$url $branch" ]
}

@test "pdcdef_get_plugins: github clone" {
    # variables
    github='user/project'

    # mocks
    pdcyml_plugins_get=( "$github" )
    pdcdef_clone_plugin() { touch "$git_file" && echo "$@" >> "$git_file"; }

    # run
    run pdcdef_get_plugins

    # asserts
    [ "$status" -eq 0 ]
    [ "$(cat $git_file)" = "https://github.com/${github}.git " ]
}

@test "pdcdef_get_plugins: github clone, using branch" {
    # variables
    github='user/project'
    branch='master'

    # mocks
    pdcyml_plugins_get=( "$github:$branch" )
    pdcdef_clone_plugin() { touch "$git_file" && echo "$@" >> "$git_file"; }

    # run
    run pdcdef_get_plugins

    # asserts
    [ "$status" -eq 0 ]
    [ "$(cat $git_file)" = "https://github.com/${github}.git $branch" ]
}

@test "pdcdef_get_plugins: get many plugins" {
    # variables
    git_url_1='user/project:master'
    git_url_2='https://git.com/user/project.git'
    git_url_3='http://git.com/user/project:develop'

    # mocks
    pdcyml_plugins_get=( "$git_url_1" "$git_url_2" "$git_url_3" )
    pdcdef_clone_plugin() { touch "$git_file" && echo "$@" >> "$git_file"; }

    # run
    run pdcdef_get_plugins

    # asserts
    git_command[0]='https://github.com/user/project.git master'
    git_command[1]='https://git.com/user/project.git '
    git_command[2]='http://git.com/user/project develop'

    i=0
    while read line; do
        [ "${git_command[$i]}" = "$line" ]
        i=$((i + 1))
    done < "$(cat "$git_file")"

    [ "$status" -eq 0 ]
}
