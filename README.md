`ALERT: We are in alpha, nothing are realy tested or configured as the final released can be.`

[![Build status][travis-image]][travis-url]

[travis-image]: https://travis-ci.org/personal-distro-configurator/personal-distro-configurator.svg?branch=master
[travis-url]: https://travis-ci.org/personal-distro-configurator/personal-distro-configurator

# Personal Distro Configurator

Personal Distro Configurator (PDC) is a framework to install and configure everything you want on your distro. With it, you can transform a fresh linux install into your personal distro!


## Getting Started

To create your own configurator, you must create a `pdc.yml` file. This file contains informations about what and how PDC must configure your distro.

With your configuration done, you need a copy of `pdc` folder, where the magic happens.
To be simple, we done a one-line install script. You can create a `install.sh` file with this content:

    curl http://bit.ly/pdc-install -L > pdc-install.sh && sh pdc-install.sh

Now you don't need to copy anything to execute it.

### Requirements

**All you need is a linux system!**

We don't want to install or configure something that can be unhappy to do.

Currently, it's 100% bash script. But can needed python in future, what normally your distro got.


## Documentation

As this project are not done yet, we haven't created a documentation.

In future, we will create something that will help you to create a good PDC file
to configure your distro.


## Getting Involved

For now, not so much can be done to help. We are looking for the best
way to create a good framework to configure your distro.

**BUT** if you wanna help us, create an issue with a good idea, what you think can be done or something else.
We will be happy with that help!

### Contributing

We will create a `CONTRIBUTING.md` file, explaining how to help this project.

### Plugins

We have a plugin system. In `CONTRIBUTING.md` file we will explain how to create.


## Authors

A `AUTHORS` file will be created soon with everyone who helped this project.


## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
