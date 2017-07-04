#!/bin/sh

echo "Downloading project"
curl -sL "https://github.com/jasperes/personal-distro-configurator/archive/master.tar.gz" | tar xz

echo "Copy install files" && cp -r "personal-distro-configurator-master/pdc" pdc
echo "Remove downloaded files" && rm -rf "personal-distro-configurator-master"

echo "Running..." && bash pdc/install.sh
