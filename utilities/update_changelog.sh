#!/bin/bash

cd $(dirname $(readlink -f $0))
cd ..

source pdc/sh/utils/yaml.sh

version=$1
today=$(date +%Y-%m-%d)
old_changelog=$(cat CHANGELOG.md)
link_requests="https://github.com/personal-distro-configurator/personal-distro-configurator/pull/"

[ -z "$version" ] && echo "Error: Version must be informed" && exit 1

echo "## ${version} (${today})" > CHANGELOG.md
echo "" >> CHANGELOG.md

for entry in changelogs/unreleased/*; do

	while read -r line || [[ -n "$line" ]]; do
		declare "$(echo "${line}" | cut -d ':' -f1)"="$(echo ${line} | cut -d ':' -f2)"
	done < "$entry"

	[ ! -z "$pull_request" ] && pull_request="[#${pull_request# }](${link_requests}${pull_request# })"

	echo "- ${title# } ${pull_request}" >> CHANGELOG.md
done

echo "" >> CHANGELOG.md
echo "$old_changelog" >> CHANGELOG.md

rm changelogs/unreleased/*
