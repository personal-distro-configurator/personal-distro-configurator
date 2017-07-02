#!/bin/bash

function distro_update() {
    sudo pacman -Syu
}

function distro_install_dependencies() {
    eval "sudo pacman -S ${settings_dependencies[*]}"
}

function distro_install() {
    local dependencie=$1
    sudo pacman -S "$dependencie"
}

function distro_remove() {
    local dependencie=$1
    sudo pacman -Rc "$dependencie"
}
