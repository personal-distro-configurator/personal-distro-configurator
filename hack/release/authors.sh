#!/usr/bin/env bash

set -e
cd "$(dirname "$(readlink -f "$0")")"/../../

FILE='AUTHORS'

echo 'Updating AUTHORS file...'

echo '# Auto-generated file from hack/release/authors.sh' > "$FILE"
echo '' >> "$FILE"

git log --format='%aN <%aE>' | LC_ALL=C.UTF-8 sort -uf >> "$FILE"

echo 'AUTHORS file updated with success!'
