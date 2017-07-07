#!/bin/bash

function pip_install() {
    pdc_test_command "pip"
    sudo pip install "${settings_pip[*]}"
}
