#!/usr/bin/env bats

load ../helper/test_helper

setup() {
    super_setup
}

teardown() {
    super_teardown
}

# imports --------------------------------------------------------------------
@test "imports: validate all imports" {

    local sources
    sources+=( 'source sh/utils/yaml.sh' )
    sources+=( 'source sh/utils/log.sh' )
    sources+=( 'source sh/utils/lock.sh' )
    sources+=( 'source sh/init/plugins.sh' )
    sources+=( 'source sh/init/setup.sh' )
    sources+=( 'source sh/init/confirm.sh' )
    sources+=( 'source sh/init/execute.sh' )

    for s in "${sources[@]}"; do
        [ "$(grep "^$s$" < "${PDC_FOLDER}/sh/init/imports.sh")" ]
    done
}

@test "imports: validate files exists" {
    [ -f "${PDC_FOLDER}/sh/utils/yaml.sh" ]
    [ -f "${PDC_FOLDER}/sh/utils/log.sh" ]
    [ -f "${PDC_FOLDER}/sh/utils/lock.sh" ]
    [ -f "${PDC_FOLDER}/sh/init/plugins.sh" ]
    [ -f "${PDC_FOLDER}/sh/init/setup.sh" ]
    [ -f "${PDC_FOLDER}/sh/init/confirm.sh" ]
    [ -f "${PDC_FOLDER}/sh/init/execute.sh" ]
}
