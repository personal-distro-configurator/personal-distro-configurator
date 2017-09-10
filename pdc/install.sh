#!/bin/bash
# shellcheck disable=SC1091

printf "\n == Welcome to Personal Distro Configurator! == \n\n"

# Initial Settings
printf "Initial settings..."
set -e
cd "$(dirname "$(readlink -f "$0")")"
printf " ok\n"

# Imports
printf "Imports..."
source sh/init/imports.sh
printf " ok\n"

# Plugins
pdcdef_get_plugins

# Setup
pdcdef_setup

# TODO: Test

# Confirm
printf "\nStarting logs\n"
pdcdef_confirm

# Execute
pdcdef_execute

# TODO: Clean

log_info "Installation done with success!" && exit 0
