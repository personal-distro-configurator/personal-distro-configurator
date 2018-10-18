#!/usr/bin/env bash

pdcdef_yaml_parse() {
    local yaml_file=$1
    local prefix=$2
    local s
    local w
    local fs

    s='[[:space:]]*'
    w='[a-zA-Z0-9_.-]*'
    fs="$(echo @|tr @ '\034')"

    (
        sed -ne '/^--/s|--||g; s|\"|\\\"|g; s/\s*$//g;' \
            -e "/#.*[\"\']/!s| #.*||g; /^#/s|#.*||g;" \
            -e  "s|^\($s\)\($w\)$s:$s\"\(.*\)\"$s\$|\1$fs\2$fs\3|p" \
            -e "s|^\($s\)\($w\)${s}[:-]$s\(.*\)$s\$|\1$fs\2$fs\3|p" |

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

        sed -e 's/_=/+=/g' \
            -e '/\..*=/s|\.|_|' \
            -e '/\-.*=/s|\-|_|'

    ) < "$yaml_file"
}

pdcdef_yaml_createvariables() {
    local yaml_file="$1"

    local variables
    local exclude
    local settings

    parseyaml=pdcdef_yaml_parse
    readsettings=pdcdef_yaml_readsettings

    variables="$($parseyaml "$yaml_file" pdcyml_)"
    exclude="$($readsettings "$yaml_file" 'pdcyml_settings_yaml_exclude')"

    for e in ${exclude[*]}; do
        e="${e//pdcyml_settings_yaml_exclude+=\(\"/}"
        e="${e//\"\)/}"

        variables="$(sed -e "s/^$e=.*//g" -e "s/^$e+=.*//g" <<< "$variables")"
    done

    eval "$variables"
}

pdcdef_yaml_readsettings() {
    local yaml_file=$1
    local settings_to_load=$2
    local prefix='pdcyml_'

    local settings
    local variables

    parseyaml=pdcdef_yaml_parse

    variables="$($parseyaml "$yaml_file" "$prefix")"

    for setting in ${settings_to_load[*]}; do
        settings+=( "$(grep -i -e "^${setting}=" -e "^${setting}+=" <<< "$variables")" )
    done

    sed 's/ $//' <<< "${settings[@]}"
}

pdcdef_yaml_loadsettings() {
    local file=$1
    local setting=$2

    eval "$(pdcdef_yaml_readsettings "$file" "$setting")"
}
