#!/usr/bin/env bash

super_setup() {
    export PDC_FOLDER="${BATS_TEST_DIRNAME}/../../pdc"
    export RESOURCES="${BATS_TEST_DIRNAME}/../resources"
    export TEMP="${BATS_TEST_DIRNAME}/../tmp"

    [ ! -d "$TEMP" ] && mkdir "$TEMP"
}

super_teardown() {
	rm -rf "${TEMP}"
}
