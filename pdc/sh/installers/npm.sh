#!/bin/bash

function npm_install() {
    pdc_test_command "npm"
    sudo npm install -g "${settings_npm[*]}"
}
