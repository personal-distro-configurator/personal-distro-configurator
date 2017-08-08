#!/bin/bash

function pdc_execute() {

    ## TODO: Move to plugin {

    # Update distro
    #if [[ "$settings_update_distro" == "true" ]]; then
    #    log_info "Updating distro..." && log_info
    #    distro_update
    #    log_info "Distro updated!" && log_info
    #fi

    # Install all distro dependencies
    #if [[ "$settings_dependencies" != "" ]]; then
    #    log_info "Install dependencies..." && log_info
    #    distro_install_dependencies
    #    log_info "Dependencies installed with success!" && log_info
    #fi

    # Install pip
    #if [[ "$settings_pip" != "" ]]; then
    #    log_info "Running pip install..." && log_info
    #    pip_install
    #    log_info "Pip install executed with success!" && log_info
    #fi

    # Install gem
    #if [[ "$settings_gem" != "" ]]; then
    #    log_info "Running gem install..." && log_info
    #    gem_install
    #    log_info "Gem install executed with success!" && log_info
    #fi

    # Install npm
    #if [[ "$settings_npm" != "" ]]; then
    #    log_info "Running npm install..." && log_info
    #    npm_install
    #    log_info "Npm install executed with success!" && log_info
    #fi

    # --}

    log_info "Executions done!" && log_info
}
