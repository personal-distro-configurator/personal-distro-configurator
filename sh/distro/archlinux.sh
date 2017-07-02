#!/bin/bash

function distro_update() {
    sudo pacman -Syu
}

function distro_install_dependencies() {
    eval "sudo pacman -S ${settings_dependencies[*]}"
}
