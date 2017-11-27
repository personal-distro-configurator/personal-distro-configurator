#!/usr/bin/env bash

set -e
cd "$(dirname "$(readlink -f "$0")")"/../../

echo 'Updateing VERSION file...'

echo "$1" > VERSION

echo 'VERSION file updated with success!'
