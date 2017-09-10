#!/usr/bin/env bash

set -e
cd "$(dirname "$(readlink -f "$0")")"/../../

echo "$1" > VERSION
