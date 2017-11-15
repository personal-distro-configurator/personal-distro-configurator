#!/usr/bin/env bash

set -e
cd "$(dirname "$(readlink -f "$0")")"/../../

if [ ! -f "./test/run.sh" ]; then
    echo >&2 'error: Unit tests runner script not found.'
    exit 1
fi

bash ./test/run.sh
