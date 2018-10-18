#!/usr/bin/env bash
# shellcheck disable=SC2154

execute() {
    for execution in "${pdcyml_execute[@]}"; do
        for i in ${!pdcyml_executors__command[*]}; do
            if [ "${pdcyml_executors__command[$i]}" = "$(cut -d ' ' -f1 <<< "$execution")" ]; then
                "${pdcyml_executors__function[$i]}" "${execution#${pdcyml_executors__command[$i]} }"
            fi
        done
    done
}
