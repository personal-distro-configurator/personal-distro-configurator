#!/bin/bash

# Utils
source sh/utils/utils.sh
source sh/utils/yaml.sh
source sh/utils/log.sh
source sh/utils/lock.sh

# Init
source sh/init/setup.sh
source sh/init/confirm.sh
source sh/init/execute.sh

## TODO: Move to plugin {
# Distro
#source sh/distro/archlinux.sh

# Installers
#source sh/installers/pip.sh
#source sh/installers/gem.sh
#source sh/installers/npm.sh
## --}
