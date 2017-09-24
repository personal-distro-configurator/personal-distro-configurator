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
    sources+=( 'source sh/utils/utils.sh' )
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
