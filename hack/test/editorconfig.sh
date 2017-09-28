#!/usr/bin/env bash

set -e
cd "$(dirname "$(readlink -f "$0")")"/../../

if [ ! -f "./node_modules/.bin/editorconfig-checker" ]; then
    echo >&2 'error: editorconfig-checker not found'
    exit 1
fi

./node_modules/.bin/editorconfig-checker --list-files
