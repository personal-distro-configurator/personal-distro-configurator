#!/bin/bash

printf "\n == Welcome to Personal Distro Configurator! == \n\n"

# Initial Settings
printf "Initial settings..."
set -e
cd $(dirname $(readlink -f $0))
printf " ok\n"

# Imports
printf "Imports..."
source sh/init/imports.sh
printf " ok\n"

# Plugins
pdc_get_plugins

# Setup
pdc_setup

# TODO: Test

# Confirm
printf "\nStarting logs\n"
pdc_confirm

# Execute
pdc_execute

# TODO: Clean

log_info "Installation done with success!" && exit 0
