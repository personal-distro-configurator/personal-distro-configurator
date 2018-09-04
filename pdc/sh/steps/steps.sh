#!/usr/bin/env bash
# shellcheck disable=SC1091

source ./sh/steps/_setup.sh

setup

unset -f _step_setup_plugin setup

source ./sh/steps/_execute.sh
