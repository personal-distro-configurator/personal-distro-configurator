#!/usr/bin/env bash
# shellcheck disable=SC1091

set -e

export PDCCONST_RUNNING_DIR
export PDCCONST_MAIN_DIR

PDCCONST_RUNNING_DIR=$(pwd)
PDCCONST_PDC_DIR="$(dirname "${BASH_SOURCE[0]}")"

cd "$PDCCONST_PDC_DIR"

source ./sh/lib/executor.sh
source ./sh/lib/log.sh
source ./sh/lib/yaml.sh

source ./sh/init/init.sh
source ./sh/steps/steps.sh

exit 0
