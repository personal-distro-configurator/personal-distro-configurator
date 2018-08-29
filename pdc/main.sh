#!/usr/bin/env bash
# shellcheck disable=SC1091

set -e
cd "$(dirname "$(readlink -f "$0")")"

source ./sh/lib/executor.sh
source ./sh/lib/log.sh
source ./sh/lib/yaml.sh

. ./sh/init/init.sh
. ./sh/steps/steps.sh

exit 0
