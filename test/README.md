# PDC Unit Tests

This folder contains all unit tests for Personal Distro Configurator.

## Requirements

To execute, you will need [Bats](https://github.com/bats-core/bats-core).

## Running

Just execute `run.sh` file.

## Contributing

Whenever something is updated from PDC project, probably these unit tests will be needed too. To do so, some things must be know.

### Where the scripts tests are?
Find on `unit` folder. Files are separated by script name on `pdc` folder.

### You can mock everything
When you are creating a test and you need mock a variable, function or command, you can do replacing this way:

**variable**: `my_var='new value'`

**function/command**: `my_command_or_function() { echo 'operation updated!' ; }`

### You can use utils scripts on helper folder
Create an utils script on `helper` folder.

### Resources files/folders can be created to do not do manually
On folder `resources`, create another folder inside with script test file name with all you need.

### You can run a single file
Probably you want test just one file. To do, run `bats unit/filename.bats`.

### Comment all steps from your tests
Make a single comment on each step, normally they are `variables`, `mocks`, `run` and `asserts`.

### Organize all tests
All tests are separated by functions tests. To organize it, on top of it comment with `# function_name -----`, where the `-` is what need to complete 79 characters on line.

All tests have the same pattern: `test_name: what it must do`.

### Bats Helpers

- [Wiki](https://github.com/bats-core/bats-core/wiki)
- [README](https://github.com/bats-core/bats-core/blob/master/README.md)
