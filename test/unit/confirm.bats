#!/usr/bin/env bats

load ../helper/test_helper

setup() {
    super_setup
    source "${PDC_FOLDER}/sh/init/confirm.sh"

    #mocks
    VERBOSE=false
    LOG_FILE="${TEMP}/log"

    [ -f "$LOG_FILE" ] && rm "$LOG_FILE"

    log_info() { echo "$1" >> "$LOG_FILE"; }
    log_verbose() { [ "${VERBOSE}" = true ] && echo "$1" >> "$LOG_FILE"; }
}

teardown() {
    super_teardown
}

# pdcdef_confirm_header ------------------------------------------------------
@test "pdcdef_confirm_header: validate output message" {
    # mocks
    date() { echo '%date%'; }

    # run
    run pdcdef_confirm_header

    # asserts
    [ "$status" -eq 0 ]
    [ "$(grep 'Personal Distro Configurator install at %date%' < "$LOG_FILE" )" ]
    [ "$(grep 'The corresponding instalation will be done:' < "$LOG_FILE" )" ]
}

# pdcdef_confirm_yaml --------------------------------------------------------
@test "pdcdef_confirm_yaml: show number of settings to add" {
    #variables
    i=0

    # mocks
    pdcyml_yaml=( 'ok1' 'ok2' 'ok3' )
    log_info() { echo ; }
    log_verbose() { [ "$i" -eq 0 ] && echo "$1" >> "$LOG_FILE" ; ((i+=1)) ; }

    # run
    pdcdef_confirm_yaml

    # asserts
    [ "$(cat $LOG_FILE)" = '# YAML Settings to add (3):' ]
}

@test "pdcdef_confirm_yaml: show settings to add" {
    # variables
    tcount="${TEMP}/tcount"

    # mocks
    pdcyml_yaml=( 'setting' 'setting' 'setting' 'setting' 'setting' )
    log_info() { echo ; }
    log_verbose() { [ "$1" = 'setting' ] && echo "$1" >> "$LOG_FILE" ; }

    # run
    pdcdef_confirm_yaml

    # asserts
    i=0
    for value in $(cat $LOG_FILE); do
        [ 'setting' = "$value" ]
        i=$((i + 1)) && echo "$i" > "$tcount"
    done

    [ "$(cat "$tcount")" = '5' ]
}

@test "pdcdef_confirm_yaml: log only on verbose mode" {
    # variables
    log_file="${TEMP}/log_file"
    verbose_file="${TEMP}/verbose_file"

    # mocks
    pdcyml_yaml=( 'setting' 'setting' 'setting' 'setting' 'setting' )
    log_info() { touch "$log_file" ; }
    log_verbose() { touch "$verbose_file" ; }

    # run
    pdcdef_confirm_yaml

    # asserts
    [ ! -f "$log_file" ]
    [ -f "$verbose_file" ]
}

# pdcdef_confirm_executions --------------------------------------------------
@test "pdcdef_confirm_executions: log when have executions" {
    # mocks
    pdcyml_execute=( 'ok' 'ok' 'ok' )
    log_info() { echo ; }
    log_verbose() { echo "$1" >> "$LOG_FILE" ; }

    # run
    run pdcdef_confirm_executions

    # asserts
    [ "$status" -eq 0 ]
    [ "$(cat "$LOG_FILE")" = '# User execute lines to run: 3' ]
}

@test "pdcdef_confirm_executions: do not log when have no executions" {
    # mocks
    pdcyml_execute=()
    log_info() { echo ; }
    log_verbose() { echo "$1" >> "$LOG_FILE" ; }

    # run
    run pdcdef_confirm_executions

    # asserts
    [ "$status" -eq 0 ]
    [ ! -f "$LOG_FILE" ]
}

@test "pdcdef_confirm_executions: log only on verbose" {
    # variables
    log_file="${TEMP}/log_file"
    verbose_file="${TEMP}/verbose_file"

    # mocks
    pdcyml_execute=( 'ok' )
    log_info() { touch  "$log_file" ; }
    log_verbose() { touch "$verbose_file" ; }

    # run
    run pdcdef_confirm_executions

    # asserts
    [ "$status" -eq 0 ]
    [ -f "$verbose_file" ]
    [ ! -f "$log_file" ]
}

# pdcdef_confirm_plugins -----------------------------------------------------
@test "pdcdef_confirm_plugins: show number of plugins to add" {
    #variables
    i=0

    # mocks
    pdcyml_plugins=( 'ok1' 'ok2' 'ok3' )
    log_info() { echo ; }
    log_verbose() { [ "$i" -eq 0 ] && echo "$1" >> "$LOG_FILE" ; ((i+=1)) ; }

    # run
    pdcdef_confirm_plugins

    # asserts
    [ "$(cat $LOG_FILE)" = '# Plugins add (3):' ]
}

@test "pdcdef_confirm_plugins: show plugins to add" {
    # variables
    tcount="${TEMP}/tcount"

    # mocks
    pdcyml_plugins=( 'plugin' 'plugin' 'plugin' 'plugin' 'plugin' )
    log_info() { echo ; }
    log_verbose() { [ "$1" = 'plugin' ] && echo "$1" >> "$LOG_FILE" ; }

    # run
    pdcdef_confirm_plugins

    # asserts
    i=0
    for value in $(cat $LOG_FILE); do
        [ 'plugin' = "$value" ]
        i=$((i + 1)) && echo "$i" > "$tcount"
    done

    [ "$(cat "$tcount")" = '5' ]
}

@test "pdcdef_confirm_plugins: log only on verbose mode" {
    # variables
    log_file="${TEMP}/log_file"
    verbose_file="${TEMP}/verbose_file"

    # mocks
    pdcyml_plugins=( 'plugin' 'plugin' 'plugin' 'plugin' 'plugin' )
    log_info() { touch "$log_file" ; }
    log_verbose() { touch "$verbose_file" ; }

    # run
    pdcdef_confirm_plugins

    # asserts
    [ ! -f "$log_file" ]
    [ -f "$verbose_file" ]
}

# pdcdef_confirm_plugins_step ------------------------------------------------
@test "pdcdef_confirm_plugins_step: do not confirm when nothing to confirm" {
    # mocks
    pdcyml_plugin_confirm=( )

    # run
    run pdcdef_confirm_plugins_step

    # asserts
    [ "$status" -eq 0 ]
}

@test "pdcdef_confirm_plugins_step: test confirmation" {
    # variables
    test_file="${TEMP}/test_file"

    # mocks
    pdcyml_plugin_confirm=( 'touch "$test_file"' )

    # run
    pdcdef_confirm_plugins_step

    # asserts
    [ -f "$test_file" ]
}

@test "pdcdef_confirm_plugins_step: test confirmations" {
    # variables
    test_file1="${TEMP}/test_file1"
    test_file2="${TEMP}/test_file2"
    test_file3="${TEMP}/test_file3"

    # mocks
    pdcyml_plugin_confirm=( 'touch "$test_file1"' 'touch "$test_file2"' 'touch "$test_file3"' )

    # run
    pdcdef_confirm_plugins_step

    # asserts
    [ -f "$test_file1" ]
    [ -f "$test_file2" ]
    [ -f "$test_file3" ]
}

# pdcdef_confirm_confirm -----------------------------------------------------
@test "pdcdef_confirm_confirm: confirm y" {
    # mocks
    read() { opt='y' ; }

    # run
    run pdcdef_confirm_confirm

    # asserts
    file_content="$(cat "$LOG_FILE")"

    expected[0]='Confirm? [Y/n]'

    i=0
    while read line; do
        [ "${expected[$i]}" = "$line" ]
        i=$((i + 1))
    done < "$file_content"

    [ "$status" -eq 0 ]
}

@test "pdcdef_confirm_confirm: confirm Y" {
    # mocks
    read() { opt='Y' ; }

    # run
    run pdcdef_confirm_confirm

    # asserts
    file_content="$(cat "$LOG_FILE")"

    expected[0]='Confirm? [Y/n]'

    i=0
    while read line; do
        [ "${expected[$i]}" = "$line" ]
        i=$((i + 1))
    done < "$file_content"

    [ "$status" -eq 0 ]
}

@test "pdcdef_confirm_confirm: confirm ''" {
    # mocks
    read() { opt='' ; }

    # run
    run pdcdef_confirm_confirm

    # asserts
    file_content="$(cat "$LOG_FILE")"

    expected[0]='Confirm? [Y/n]'

    i=0
    while read line; do
        [ "${expected[$i]}" = "$line" ]
        i=$((i + 1))
    done < "$file_content"

    [ "$status" -eq 0 ]
}

@test "pdcdef_confirm_confirm: confirm n" {
    # mocks
    read() { opt='n' ; }

    # run
    run pdcdef_confirm_confirm

    # asserts
    file_content="$(cat "$LOG_FILE")"

    expected[0]='Confirm? [Y/n]'
    expected[1]='Canceled by user'

    i=0
    while read line; do
        [ "${expected[$i]}" = "$line" ]
        i=$((i + 1))
    done < "$file_content"

    [ "$status" -eq 1 ]
}

# pdcdef_confirm -------------------------------------------------------------
@test "pdcdef_confirm: test call functions to output confirm messages" {
    # mocks
    pdcdef_confirm_header() { touch "${TEMP}/pdcdef_confirm_header"; }
    pdcdef_confirm_distro() { touch "${TEMP}/pdcdef_confirm_distro"; }
    pdcdef_confirm_yaml() { touch "${TEMP}/pdcdef_confirm_yaml"; }
    pdcdef_confirm_executions() {  touch "${TEMP}/pdcdef_confirm_executions"; }
    pdcdef_confirm_plugins() { touch "${TEMP}/pdcdef_confirm_plugins"; }
    pdcdef_confirm_plugins_step() { touch "${TEMP}/pdcdef_confirm_plugins_step"; }
    pdcdef_confirm_confirm() { touch "${TEMP}/pdcdef_confirm_confirm"; }

    # run
    run pdcdef_confirm

    # asserts
    [ "$status" -eq 0 ]
    [ -f "${TEMP}/pdcdef_confirm_header" ]
    [ -f "${TEMP}/pdcdef_confirm_distro" ]
    [ -f "${TEMP}/pdcdef_confirm_yaml" ]
    [ -f "${TEMP}/pdcdef_confirm_executions" ]
    [ -f "${TEMP}/pdcdef_confirm_plugins" ]
    [ -f "${TEMP}/pdcdef_confirm_plugins_step" ]
    [ -f "${TEMP}/pdcdef_confirm_confirm" ]
}

@test "pdcdef_confirm: test functions order" {
    # variables
    i=1

    # mocks
    pdcdef_confirm_header() { echo "$i" > "${TEMP}/pdcdef_confirm_header" ; ((i+=1)) ; }
    pdcdef_confirm_distro() { echo "$i" > "${TEMP}/pdcdef_confirm_distro" ; ((i+=1)) ; }
    pdcdef_confirm_yaml() { echo "$i" > "${TEMP}/pdcdef_confirm_yaml" ; ((i+=1)) ; }
    pdcdef_confirm_executions() {  echo "$i" > "${TEMP}/pdcdef_confirm_executions" ; ((i+=1)) ; }
    pdcdef_confirm_plugins() { echo "$i" > "${TEMP}/pdcdef_confirm_plugins" ; ((i+=1)) ; }
    pdcdef_confirm_plugins_step() { echo "$i" > "${TEMP}/pdcdef_confirm_plugins_step" ; ((i+=1)) ; }
    pdcdef_confirm_confirm() { echo "$i" > "${TEMP}/pdcdef_confirm_confirm" ; ((i+=1)) ; }

    # run
    run pdcdef_confirm

    # asserts
    [ "$status" -eq 0 ]
    [ "$(cat ${TEMP}/pdcdef_confirm_header)" = '1' ]
    [ "$(cat ${TEMP}/pdcdef_confirm_distro)"  = '2' ]
    [ "$(cat ${TEMP}/pdcdef_confirm_yaml)" = '3' ]
    [ "$(cat ${TEMP}/pdcdef_confirm_executions)" = '4' ]
    [ "$(cat ${TEMP}/pdcdef_confirm_plugins)" = '5' ]
    [ "$(cat ${TEMP}/pdcdef_confirm_plugins_step)" = '6' ]
    [ "$(cat ${TEMP}/pdcdef_confirm_confirm)" = '7' ]
}
