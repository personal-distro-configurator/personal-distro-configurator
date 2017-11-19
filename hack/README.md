# Hack

A collection of scripts to test, build, release, etc. Every step are organized in separated folders, managed by `make.sh` script.

## Usage

Use `make.sh` file as your main script, avoid use others scripts direct.

For help, use:

    make.sh help

### Test

Run tests with:

    make.sh test [OPTIONS]

Currently options avaliable:

- --syntax: Shellcheck and Editorconfig syntax validate.
- --unit: Unit tests, running with bats.
- --all: All tests.

### Release

For a release version, call:

    make.sh release --version x.x.x

* `VERSION` file will be updated with new version, informed as argument
* `CHANGELOGS` will be updated, using files found in `changelog` folder
* `AUTHORS` will be updated, based on git commits
