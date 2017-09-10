#!/bin/bash

set -e
cd "$(dirname "$(readlink -f "$0")")"

CHECK=()
CHECK+=( "../pdc/install.sh" )
CHECK+=( "../pdc/sh/init/confirm.sh" )
CHECK+=( "../pdc/sh/init/execute.sh" )
CHECK+=( "../pdc/sh/init/imports.sh" )
CHECK+=( "../pdc/sh/init/plugins.sh" )
CHECK+=( "../pdc/sh/init/setup.sh" )
CHECK+=( "../pdc/sh/utils/lock.sh" )
CHECK+=( "../pdc/sh/utils/log.sh" )
CHECK+=( "../pdc/sh/utils/yaml.sh" )

shellcheck "${CHECK[@]}" && exit 0
