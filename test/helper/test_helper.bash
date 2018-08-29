#!/usr/bin/env bash

super_setup() {
    local dir="$1"

    export PDC_FOLDER="${BATS_TEST_DIRNAME}/${dir}/../../pdc"
    export RESOURCES="${BATS_TEST_DIRNAME}/${dir}/../resources"
    export TEMP="${BATS_TEST_DIRNAME}/${dir}/../tmp"

    [ ! -d "$TEMP" ] && mkdir "$TEMP"
}

super_teardown() {
	rm -rf "${TEMP}"
}
