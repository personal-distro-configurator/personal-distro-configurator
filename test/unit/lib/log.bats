#!/usr/bin/env bats

load ../../helper/test_helper

setup() {
    super_setup ".."
    source "${PDC_FOLDER}/sh/lib/log.sh"

    export pdcyml_path_log="$TEMP"
    export pdcyml_settings_file_log='install.log'
    export pdcyml_settings_verbose=false

    export LOG_FILE="${pdcyml_path_log}/${pdcyml_settings_file_log}"
}

teardown() {
    super_teardown
}

# pdcdef_log_info -------------------------------------------------------------------
@test "pdcdef_log_info: write to log file" {
    run pdcdef_log_info 'test 123'

    [ "$(cat $LOG_FILE)" = 'test 123' ]
}

@test "pdcdef_log_info: create log folder if not exist" {
    pdcyml_path_log="${TEMP}/logfolder"

    run pdcdef_log_info 'test 123'

    [ -d "$pdcyml_path_log" ]
}

@test "pdcdef_log_info: create log file if not exist" {
    pdcyml_path_log="${TEMP}/logfolder"
    mkdir "$pdcyml_path_log"

    run pdcdef_log_info 'test 123'

    [ -f "${pdcyml_path_log}/${pdcyml_settings_file_log}" ]
}

@test "pdcdef_log_info: when log folder don't exist, log file must be updated" {
    pdcyml_path_log="${TEMP}/logfolder"

    run pdcdef_log_info 'test 123'

    [ "$(cat ${pdcyml_path_log}/${pdcyml_settings_file_log})" = 'test 123' ]
}

@test "pdcdef_log_info: when log file don't exist, it must be created and updated" {
    pdcyml_path_log="${TEMP}/logfolder"
    mkdir "$pdcyml_path_log"

    run pdcdef_log_info 'test 123'

    [ "$(cat ${pdcyml_path_log}/${pdcyml_settings_file_log})" = 'test 123' ]
}

# pdcdef_log_verbose ----------------------------------------------------------------
@test "pdcdef_log_verbose: update log when verbose true" {
    pdcyml_settings_verbose=true

    run pdcdef_log_verbose 'test 890'

    [ "$(cat $LOG_FILE)" = 'test 890' ]
}

@test "pdcdef_log_verbose: don't update log when verbose false" {
    pdcyml_settings_verbose=false

    run pdcdef_log_verbose 'test 890'

    [ "$(cat $LOG_FILE)" = '' ]
}
