#!/usr/bin/env bash
# shellcheck disable=SC1091

source ./sh/init/_setup.sh
source ./sh/init/_lockfile.sh
source ./sh/init/_import.sh
source ./sh/init/_settings.sh
source ./sh/init/_plugins.sh

create_variables
create_paths
lockfile
get_plugins
read_settings
import_shell_files

unset -f _plugin_import _user_import import_shell_files lockfile \
_clone_plugin _download_plugin _copy_plugin get_plugins \
_step_settings_plugins _step_settings_user read_settings \
_create_if_not_exists create_variables create_paths
