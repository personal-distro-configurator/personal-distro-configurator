#!/usr/bin/env bash

set -e
cd "$(dirname "$(readlink -f "$0")")"/../../

source pdc/sh/utils/yaml.sh

VERSION=$(cat VERSION)
TODAY=$(date +%Y-%m-%d)
FILE='CHANGELOG.md'
OLD_CHANGELOG=$(sed '/^*Auto-generated/ d' < "$FILE")
LINK_PULL_REQUESTS='https://github.com/personal-distro-configurator/personal-distro-configurator/pull/'

# Verify if everything is ok to update changelog
# VERSION file must be not empty
if [ -z "$VERSION" ]; then
    echo >&2 'error: VERSION file are empty'
    exit 1

# CHANGELOG.md must exist
elif [ ! -f "$FILE" ]; then
    echo >&2 'error: CHANGELOG.md file not found'
    exit 1

# Must exist changes on changelogs folder
# It do not stop script, only show a warning asking if it is ok
elif [ -z "$(ls changelogs/ 2>/dev/null)" ]; then
    echo -n 'changelogs are empty, is it correctly? [y/N]'
    read -r yesno

    case $yesno in
        [yY] )
            echo 'continuing...'
            exit 0
            ;;
        [nN] | *)
            echo >&2 'exiting...'
            exit 1
            ;;
    esac
fi

# Start write to CHANGELOG
echo '*Auto-generated file from hack/release/changelog.sh*' > "$FILE"
echo "## ${VERSION} (${TODAY})" >> "$FILE"
echo "" >> "$FILE"

# Write every changelog on changelogs folder
for entry in changelogs/*; do

    # declare variables
    declare title=''
    declare pull_request=''

    # Update variables, reading from changelog file
    while read -r line || [[ -n "$line" ]]; do
        declare "$(echo "${line}" | cut -d ':' -f1)"="$(echo "${line}" | cut -d ':' -f2)"
    done < "$entry"

    # Valid and update pull request link, with github pull requests endress
    [ ! -z "$pull_request" ] && pull_request="[#${pull_request# }](${LINK_PULL_REQUESTS}${pull_request# })"

    # Finale, write a line on CHANGELOG
    echo "- ${title# } ${pull_request}" >> "$FILE"
done

# Write old content
echo "" >> "$FILE"
echo "$OLD_CHANGELOG" >> "$FILE"

# Clean changelogs writed to CHANGELOG file
rm changelogs/*
