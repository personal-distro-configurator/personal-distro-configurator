#!/usr/bin/env bats

load ../helper/test_helper

setup() {
    super_setup

    source "${PDC_FOLDER}/sh/utils/yaml.sh"

    export YAML_SIMPLE="${RESOURCES}/yaml/simple.yml"
    export YAML_COMPLEX="${RESOURCES}/yaml/complex.yml"
    export YAML_PDC="${RESOURCES}/yaml/pdc.yml"
}

teardown() {
    super_teardown
}

# parse_yaml -----------------------------------------------------------------
@test "parse_yaml: parse a yaml file" {
    # run
    output="$(parse_yaml "$YAML_SIMPLE")"

    # asserts
    [ "$output" = 'simple_test=("ok")' ]
}

@test "parse_yaml: parse a complex yaml file" {
    # run
    output="$(parse_yaml "$YAML_COMPLEX")"

    # asserts
    tcount="${TEMP}/tcount"

    settings[0]='person_name=("Snow")'
    settings[1]='person_age=("99")'
    settings[2]='person_from=("Tokyo")'

    i=0
    for out in ${output[*]}; do
        [ "${settings[$i]}" = "$out" ]
        i=$((i + 1)) && echo "$i" > "$tcount"
    done

    [ "$(cat "$tcount")" = '3' ]
}

@test "parse_yaml: parse a yaml file, with prefix" {
    # run
    output="$(parse_yaml "$YAML_SIMPLE" pdcyml_)"

    # asserts
    [ "$output" = 'pdcyml_simple_test=("ok")' ]
}

@test "parse_yaml: do not create variables on parse yaml" {
    # run
    output="$(parse_yaml "$YAML_SIMPLE")"

    # asserts
    [ "$simple_test" = '' ]
}

# pdcdef_load_settings -------------------------------------------------------
@test "pdcdef_load_settings: read only specified setting" {
    # run
    output="$(pdcdef_load_settings "$YAML_COMPLEX" "pdcyml_person_age")"

    # asserts
    [ "$output" = 'pdcyml_person_age=("99")' ]
}

@test "pdcdef_load_settings: read only specified setting listed" {
    # run
    output="$(pdcdef_load_settings "$YAML_COMPLEX" "pdcyml_person_name pdcyml_person_age")"

    # asserts
    tcount="${TEMP}/tcount"

    settings[0]='pdcyml_person_name=("Snow")'
    settings[1]='pdcyml_person_age=("99")'

    i=0
    for out in ${output[*]}; do
        [ "${settings[$i]}" = "$out" ]
        i=$((i + 1)) && echo "$i" > "$tcount"
    done

    [ "$(cat "$tcount")" = '2' ]
}

@test "pdcdef_load_settings: organize list based on arguments" {
    # run
    output="$(pdcdef_load_settings "$YAML_COMPLEX" "pdcyml_person_age pdcyml_person_name")"

    # asserts
    tcount="${TEMP}/tcount"
    settings[0]='pdcyml_person_age=("99")'
    settings[1]='pdcyml_person_name=("Snow")'

    i=0
    for out in ${output[*]}; do
        [ "${settings[$i]}" = "$out" ]
        i=$((i + 1)) && echo "$i" > "$tcount"
    done

    [ "$(cat "$tcount")" = '2' ]
}

@test "pdcdef_load_settings: do not create variables on read yaml" {
    # run
    output="$(pdcdef_load_settings "$YAML_COMPLEX" "pdcyml_person_age")"

    # asserts
    [ "$pdcyml_person_age" = '' ]
}

# pdcdef_create_variables ----------------------------------------------------
@test "pdcdef_create_variables: must create variable" {
    # run
    pdcdef_create_variables "$YAML_SIMPLE"

    # asserts
    [ "$pdcyml_simple_test" = "ok" ]
}

@test "pdcdef_create_variables: must create all variables" {
    # run
    pdcdef_create_variables "$YAML_COMPLEX"

    # asserts
    [ "$pdcyml_person_name" = "Snow" ]
    [ "$pdcyml_person_age" = "99" ]
    [ "$pdcyml_person_from" = "Tokyo" ]
}

@test "pdcdef_create_variables: ignore variables configured to exclude" {
    # run
    pdcdef_create_variables "$YAML_PDC"

    # asserts
    [ "$pdcyml_ignore_me" = '' ]
    [ "$pdcyml_ignore_me_too" = '' ]
    [ "$pdcyml_another_to_ignore" = '' ]
    [ "$pdcyml_system_wm" = "\"i3\"" ] # validate that variables are created
}

@test "pdcdef_create_variables: create all variables from a 'pdc.yml' file" {
    # run
    pdcdef_create_variables "$YAML_PDC"

    # asserts
    [ "$pdcyml_system_distro" = "\"archlinux\"" ]
    [ "$pdcyml_system_arch" = "\"x86_64\"" ]
    [ "$pdcyml_system_wm" = "\"i3\"" ]

    # asserts1
    tcount1="${TEMP}/tcount1"

    plugins[0]='user/project'
    plugins[1]='https://git.com/user/project.git'
    plugins[2]='git@git.com:user/project.git'
    plugins[3]='path:://path/to/plugin'
    plugins[4]='tarball::endpoint/to/tarbal.tar'

    i=0
    for plugin in ${pdcyml_plugins[*]}; do
        [ "${plugins[$i]}" = "$plugin" ]
        i=$((i + 1)) && echo "$i" > "$tcount1"
    done

    [ "$(cat "$tcount1")" = '5' ]

    # asserts2
    tcount2="${TEMP}/tcount2"

    execute[0]='plugin plugin-name'
    execute[1]='bash myFile.sh'
    execute[2]='shell echo something'

    i=0
    for exe in "${pdcyml_execute[@]}"; do
        [ "${execute[$i]}" = "$exe" ]
        i=$((i + 1)) && echo "$i" > "$tcount2"
    done

    [ "$(cat "$tcount2")" = '3' ]
}
