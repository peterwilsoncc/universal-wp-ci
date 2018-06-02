# Universal WP CI

## Installation

Local development requires [Chassis](http://chassis.io) running on a
[Vagrant]((https://www.vagrantup.com/)) box.

Following these steps will give you a local development environment to work on.

On your local machine run the following steps, replacing `project-name` with
the name of your project:

```bash
git clone --recursive git@github.com:chassis/chassis project-name
cd project-name
git clone --recursive git@github.com:peterwilsoncc/universal-wp-ci.git content
cd content
```

If you wish to override any of the settings, create your own local Chassis
config file `config.local.yaml` and copy over any values you wish to override.

For shared projects, modify the `config.yaml` and commit the changes to your repo.

On your local machine, initialise your vagrant development. This will take a few
moments to run so you might want to do a few chores while you wait.

```bash
vagrant up
```

Now you need to install dependencies on the Chassis box with the following
commands. The first command gets you into Chassis, subsequent commands are
run on the box.

```bash
vagrant ssh
cd /vagrant/content
bash .chassis/bin/install-composer.sh
sudo mv composer.phar /usr/local/bin/composer
composer install
```

## Tests

This repo includes configuration files for running tests on both
[Travis CI](https://travis-ci.org/) and [Circle CI](https://circleci.com/).

It runs two sets of tests, **coding standards** and **PHP unit tests**.

### Coding standards

These tests use the [Human Made Coding Standards](https://engineering.hmn.md/how-we-work/style/)
for running PHP code style sniffs.

You can modify the coding standards in use by editing the `phpcs.ruleset.xml` file.
