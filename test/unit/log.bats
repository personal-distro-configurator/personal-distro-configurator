#!/usr/bin/env bats

load ../helper/test_helper

setup() {
    super_setup
    source "${PDC_FOLDER}/sh/utils/log.sh"

    export pdcyml_settings_path_log="$TEMP"
    export pdcyml_settings_file_log='install.log'
    export pdcyml_settings_verbose=false

    export LOG_FILE="${pdcyml_settings_path_log}/${pdcyml_settings_file_log}"
}

teardown() {
    super_teardown
}

# pdcdef_log -----------------------------------------------------------------
@test "pdcdef_log: update log file" {
    touch "$LOG_FILE"
    pdcdef_log 'test 123'

    [ "$(cat $LOG_FILE)" = 'test 123' ]
}

@test "pdcdef_log: update log file, without removing old content" {
    echo 'test 456' > "$LOG_FILE"
    pdcdef_log 'test 123'

    echo 'test 456' > "${TEMP}/expected"
    echo 'test 123' >> "${TEMP}/expected"

    [ "$(grep -F -f $LOG_FILE ${TEMP}/expected)" ]
}

# log_info -------------------------------------------------------------------
@test "log_info: write to log file" {
    log_info 'test 123'

    [ "$(cat $LOG_FILE)" = 'test 123' ]
}

@test "log_info: create log folder if not exist" {
    pdcyml_settings_path_log="${TEMP}/logfolder"
    log_info 'test 123'

    [ -d "$pdcyml_settings_path_log" ]
}

@test "log_info: create log file if not exist" {
    pdcyml_settings_path_log="${TEMP}/logfolder"
    mkdir "$pdcyml_settings_path_log"
    log_info 'test 123'

    [ -f "${pdcyml_settings_path_log}/${pdcyml_settings_file_log}" ]
}

@test "log_info: when log folder don't exist, log file must be updated" {
    pdcyml_settings_path_log="${TEMP}/logfolder"
    log_info 'test 123'

    [ "$(cat ${pdcyml_settings_path_log}/${pdcyml_settings_file_log})" = 'test 123' ]
}

@test "log_info: when log file don't exist, it must be created and updated" {
    pdcyml_settings_path_log="${TEMP}/logfolder"
    mkdir "$pdcyml_settings_path_log"
    log_info 'test 123'

    [ "$(cat ${pdcyml_settings_path_log}/${pdcyml_settings_file_log})" = 'test 123' ]
}

# log_verbose ----------------------------------------------------------------
@test "log_verbose: update log when verbose true" {
    pdcyml_settings_verbose=true
    log_verbose 'test 890'

    [ "$(cat $LOG_FILE)" = 'test 890' ]
}

@test "log_verbose: don't update log when verbose false" {
    pdcyml_settings_verbose=false
    log_verbose 'test 890'

    [ "$(cat $LOG_FILE)" = '' ]
}
