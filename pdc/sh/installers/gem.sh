#!/bin/bash

function gem_install() {
    (pdc_test_command "gem" && gem install "${settings_gem[*]}") || pdc_command_not_found "gem"
}
