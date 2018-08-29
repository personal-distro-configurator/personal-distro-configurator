#!/usr/bin/env bash

cd "$(dirname "$(readlink -f "$0")")" || exit 1

#if ! type bats > /dev/null; then
#    echo 'error: bats not found'
#    exit 1
#fi

../node_modules/.bin/bats ./unit/*
