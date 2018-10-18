#!/usr/bin/env bash
# shellcheck disable=SC1091

source ./sh/steps/_setup.sh
source ./sh/steps/_execute.sh

setup
execute

unset -f _step_setup_plugin setup execute

