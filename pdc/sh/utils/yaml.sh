#!/bin/bash
# shellcheck disable=SC2154

# Credits to https://github.com/jasperes/bash-yaml/
#
# Read an yaml file and create variables with these configs
#
# @arg1: path to yaml file
# @arg2: (optional) prefix for variables
#
# Result example, with yaml:
#
# person:
#   name: John
#   age: 30
#
# Will result in variables:
#
# person_name=John
# person_age=30
#
function parse_yaml() {
    local yaml_file=$1
    local prefix=$2
    local s
    local w
    local fs

    s='[[:space:]]*'
    w='[a-zA-Z0-9_]*'
    fs="$(echo @|tr @ '\034')"

    (
        sed -ne 's/--//g; s/\"/\\\"/g; s/\#.*//g; s/\s*$//g;' \
            -e  "s|^\($s\)\($w\)$s:$s\"\(.*\)\"$s\$|\1$fs\2$fs\3|p" \
            -e "s|^\($s\)\($w\)$s[:-]$s\(.*\)$s\$|\1$fs\2$fs\3|p" |
        awk -F"$fs" '{
            indent = length($1)/2;
            if (length($2) == 0) { conj[indent]="+";} else {conj[indent]="";}
            vname[indent] = $2;
            for (i in vname) {if (i > indent) {delete vname[i]}}
                if (length($3) > 0) {
                    vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
                    printf("%s%s%s%s=(\"%s\")\n", "'"$prefix"'",vn, $2, conj[indent-1],$3);
                }
            }' |
        sed 's/_=/+=/g'
    ) < "$yaml_file"
}

# Read an yaml file and create variables, using parse_yaml function.
# Variables configured to be excluded will be ignored
#
# @arg1: path to yaml file
#
function pdcdef_create_variables() {
    printf "Loading settings...\n"

    local yaml_file="$1"

    local variables
    local exclude
    local settings

    variables="$(parse_yaml "$yaml_file" pdcyml_)"
    exclude="$(pdcdef_load_settings "$yaml_file" pdcyml_settings_exclude)"

    for e in ${exclude[*]}; do
        settings+=( "$(sed "s/\b$e\b//g" <<< "$variables")" )
    done

    eval "$variables"

    printf "Settings loaded!\n"
}

# Read an yaml file and output a list of settings
# to be created as variables
#
# @arg1: path to yaml file
# @arg2: list of settings to filter in yaml
#
function pdcdef_load_settings() {
    local yaml_file=$1
    local settings_to_load=$2

    local settings
    local variables

    variables="$(parse_yaml "$yaml_file" pdcyml_)"

    for setting in $settings_to_load; do
        settings+=( "$(grep "^${setting}=" <<< "$variables")" )
        settings+=( "$(grep "^${setting}+=" <<< "$variables")" )
    done

    sed 's/ $//' <<< "${settings[@]}"
}
