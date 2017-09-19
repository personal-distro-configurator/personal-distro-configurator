#!/usr/bin/env bash

set -e
cd "$(dirname "$(readlink -f "$0")")"

usage() {
    echo 'usage: make COMMAND [options]'
    echo
    echo 'List of Commands:'
    echo
    echo 'test                                   execute tests informed by arument'
    echo '  --syntax                             validate syntax with shellcheck'
    echo '  --all                                run every tests'
    echo
    echo 'release                                configure files for a release version, such as authors, changelog and version'
    echo '  --version, -v [version]              release version. format: xx.xx.xx, such as 1.12.3'
    echo
    echo 'help, --help, -h                       show this help'
}

# -- SCRIPTS -----------------------------------------------------------------
run_tests() {
    declare -A tests=( ['--syntax']=0 ['--all']=0 )

    for arg in "$@"; do
        if [[ -z "${tests[$arg]}" ]]; then
            echo >&2 "error: $arg is a invalid argument"
            usage >&2
            exit 1
        fi
    done

    while test "$#" -gt 0; do
        case "$1" in
            --syntax)
                bash ./test/shellcheck.sh
                ;;
            --all)
                bash ./test/shellcheck.sh
                ;;
            *)
                echo >&2 "error: $1 is a invalid argument"
                usage >&2
                exit 1
                ;;
        esac

        shift
    done
}

run_release() {
    local VERSION=''

    while test "$#" -gt 0; do
        case "$1" in
            --version | -v)
                shift
                VERSION=$1
                shift
                ;;
            *)
                echo >&2 "error: $1 is a invalid argument"
                usage >&2
                exit 1
                ;;
        esac
    done

    if [ "$VERSION" = '' ]; then
        echo >&2 'error: version must be informed'
        usage >&2
        exit 1

    elif [[ ! "$VERSION" =~ ^([0-9]{1,2}).([0-9]{1,2}).([0-9]{1,2})$ ]]; then
        echo >&2 'error: version did not match in correctly format'
        usage >&2
        exit 1
    fi
    
    bash ./release/version.sh "$VERSION"
    bash ./release/authors.sh
    bash ./release/changelog.sh
}

# -- MAIN --------------------------------------------------------------------
COMMAND=$1

shift

case $COMMAND in
    test)
        run_tests "$@"
        ;;
    release)
        run_release "$@"
        ;;

    help | --help | -h)
        usage
        ;;
    *)
        echo >&2 'error: invalid command'
        usage >&2
        exit 1
        ;;
esac

exit 0
