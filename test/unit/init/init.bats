#!/usr/bin/env bats

load ../../helper/test_helper

setup() {
    super_setup ".."
}

teardown() {
    super_teardown
}

# init.sh --------------------------------------------------------------------
@test "init.sh: validate imports" {
    # variables
    test_file="${TEMP}/test_file"

    # mocks
    source() { echo "$@" >> "$test_file" ; }

    # run
    run . "${PDC_FOLDER}/sh/init/init.sh"

    # asserts
    [ "$status" -eq 0 ]
    [ -f "$test_file" ]
    [ $(cat "$test_file" | grep './sh/init/_setup.sh') ]
    [ $(cat "$test_file" | grep './sh/init/_lockfile.sh') ]
    [ $(cat "$test_file" | grep './sh/init/_import.sh') ]
    [ $(cat "$test_file" | grep './sh/init/_settings.sh') ]
    [ $(cat "$test_file" | grep './sh/init/_plugins.sh') ]
}

@test "init.sh: validate execution order" {
    # variables
    test_file="${TEMP}/test_file"

    # mocks
    source() { return ; }
    create_variables() { echo "1" >> "$test_file" ; }
    create_paths() { echo "2" >> "$test_file" ; }
    lockfile() { echo "3" >> "$test_file" ; }
    get_plugins() { echo "4" >> "$test_file" ; }
    read_settings() { echo "5" >> "$test_file" ; }
    import_shell_files() { echo "6" >> "$test_file" ; }

    # run
    run . "${PDC_FOLDER}/sh/init/init.sh"

    # asserts
    [ "$status" -eq 0 ]
    [ -f "$test_file" ]

    count=0
    while read line; do
        [ "$line" == $((count+=1)) ]
    done < "$test_file"
}

@test "init.sh: validate unset imports" {
    # imports
    source "${PDC_FOLDER}/sh/init/_setup.sh"
    source "${PDC_FOLDER}/sh/init/_lockfile.sh"
    source "${PDC_FOLDER}/sh/init/_import.sh"
    source "${PDC_FOLDER}/sh/init/_settings.sh"
    source "${PDC_FOLDER}/sh/init/_plugins.sh"

    # variables
    test_file="${TEMP}/test_file"
    test_imports="${TEMP}/test_imports"

    # mocks
    source() { echo 'test' >> "$test_imports" ; }
    create_variables() { return ; }
    create_paths() { return ; }
    lockfile() { return ; }
    get_plugins() { return ; }
    read_settings() { return ; }
    import_shell_files() { return ; }

    # run
    . "${PDC_FOLDER}/sh/init/init.sh"
    declare -F | awk '{print $3}' > "$test_file"

    # asserts
    [ -f "$test_file" ]
    [ $(wc -l < "$test_imports") == 5 ]

    for func in $(cat "$test_file"); do
        [ ! $(cat "${PDC_FOLDER}/sh/init/_setup.sh" | grep "${func}() {") ]
        [ ! $(cat "${PDC_FOLDER}/sh/init/_lockfile.sh" | grep "${func}() {") ]
        [ ! $(cat "${PDC_FOLDER}/sh/init/_import.sh" | grep "${func}() {") ]
        [ ! $(cat "${PDC_FOLDER}/sh/init/_settings.sh" | grep "${func}() {") ]
        [ ! $(cat "${PDC_FOLDER}/sh/init/_plugins.sh" | grep "${func}() {") ]
    done
}
