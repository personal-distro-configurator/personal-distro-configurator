#!/bin/bash

printf "\n == Welcome to Personal Distro Configurator! == \n\n"

# 0.init
printf "Initial settings..."
set -e
cd $(dirname $(readlink -f $0))
printf " ok\n"

# 1.imports
printf "Imports..."
source sh/init/imports.sh
printf " ok\n"

# 2.Setup
pdc_setup

# 3.Test

# 4.confirm
printf "\nStarting logs\n"
pdc_confirm

# 5.Execute
pdc_execute

# 6.Clean

log_info "Installation done with success!" && exit 0
