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
    output="$(parse_yaml "$YAML_SIMPLE")"

    [ "$output" = 'simple_test=("ok")' ]
}

@test "parse_yaml: parse a complex yaml file" {
    output="$(parse_yaml "$YAML_COMPLEX")"

    settings[0]='person_name=("Snow")'
    settings[1]='person_age=("99")'
    settings[2]='person_from=("Tokyo")'

    i=0
    for out in ${output[*]}; do
        [ "${settings[$i]}" = "$out" ]
        i=$((i + 1))
    done
}

@test "parse_yaml: parse a yaml file, with prefix" {
    output="$(parse_yaml "$YAML_SIMPLE" pdcyml_)"

    [ "$output" = 'pdcyml_simple_test=("ok")' ]
}

@test "parse_yaml: do not create variables on parse yaml" {
    output="$(parse_yaml "$YAML_SIMPLE")"

    [ "$simple_test" = '' ]
}

# pdcdef_load_settings -------------------------------------------------------
@test "pdcdef_load_settings: read only specified setting" {
    output="$(pdcdef_load_settings "$YAML_COMPLEX" "pdcyml_person_age")"

    [ "$output" = 'pdcyml_person_age=("99")' ]
}

@test "pdcdef_load_settings: read only specified setting listed" {
    output="$(pdcdef_load_settings "$YAML_COMPLEX" "pdcyml_person_name pdcyml_person_age")"

    settings[0]='pdcyml_person_name=("Snow")'
    settings[1]='pdcyml_person_age=("99")'

    i=0
    for out in ${output[*]}; do
        [ "${settings[$i]}" = "$out" ]
        i=$((i + 1))
    done
}

@test "pdcdef_load_settings: organize list based on arguments" {
    output="$(pdcdef_load_settings "$YAML_COMPLEX" "pdcyml_person_age pdcyml_person_name")"

    settings[0]='pdcyml_person_age=("99")'
    settings[1]='pdcyml_person_name=("Snow")'

    i=0
    for out in ${output[*]}; do
        [ "${settings[$i]}" = "$out" ]
        i=$((i + 1))
    done
}

@test "pdcdef_load_settings: do not create variables on read yaml" {
    output="$(pdcdef_load_settings "$YAML_COMPLEX" "pdcyml_person_age")"

    [ "$pdcyml_person_age" = '' ]
}

# pdcdef_create_variables ----------------------------------------------------
@test "pdcdef_create_variables: must create variable" {
    pdcdef_create_variables "$YAML_SIMPLE"

    [ "$pdcyml_simple_test" = "ok" ]
}

@test "pdcdef_create_variables: must create all variables" {
    pdcdef_create_variables "$YAML_COMPLEX"

    [ "$pdcyml_person_name" = "Snow" ]
    [ "$pdcyml_person_age" = "99" ]
    [ "$pdcyml_person_from" = "Tokyo" ]
}

@test "pdcdef_create_variables: ignore variables configured to exclude" {
    pdcdef_create_variables "$YAML_PDC"

    [ "$pdcyml_person_ignore_me" = '' ]
    [ "$pdcyml_person_ignore_me_too" = '' ]
    [ "$pdcyml_person_another_to_ignore" = '' ]
}

@test "pdcdef_create_variables: create all variables from a 'pdc.yml' file" {
    pdcdef_create_variables "$YAML_PDC"

    [ "$pdcyml_system_distro" = '"archlinux"' ]
    [ "$pdcyml_system_arch" = '"x86_64"' ]
    [ "$pdcyml_system_wm" = '"i3"' ]

    plugins[0]='user/project'
    plugins[1]='https://git.com/user/project.git'
    plugins[2]='git@git.com:user/project.git'
    plugins[3]='path:://path/to/plugin'
    plugins[4]='tarball::endpoint/to/tarbal.tar'

    i=0
    for plugin in ${pdcyml_system_plugins_get[*]}; do
        [ "${plugins[$i]}" = "$plugin" ]
        i=$((i + 1))
    done

    execute[0]='plugin plugin-name'
    execute[1]='bash myFile.sh'
    execute[2]='shell echo something'

    i=0
    for exe in ${pdcyml_person_execute[*]}; do
        [ "${execute[$i]}" = "$exe" ]
        i=$((i + 1))
    done
}
