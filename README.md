# DICE Chef Repository

This repository contains Chef cookbooks that are used by
[DICE TOSCA library][tosca-library]. Note that since cookbooks in this
repository are meant to be used in conjunction with Cloudify, their standalone
usage is a bit more complicated, since quite a few attributes does not have a
sensible default value and need to be supplied at runtime.

[tosca-library]: https://github.com/dice-project/DICE-Deployment-Cloudify


## Setting up development environment

In order to start developing cookbooks, we need to install Chef development
kit. If we follow the [installation instructions][chefdk-install], we should
be fine.

Next, we will install sftp transport plugin for kitchen. This is not strictly
necessary, but since built-in scp transport is really slow, we strongly
recommend installing it. And it is easy too:

    $ chef gem install kitchen-sync

Now we are ready to start adding bugs to our code base.

[chefdk-install]: https://docs.chef.io/install_dk.html


## Testing of Chef cookbooks

Testing of Chef cookbooks locally (that is, without berks getting in a way and
downloading stuff from 3rd party sites) is science in itself. In order to ease
the burden for developers, there are two helper scripts present in this
repository.


### Running integration tests

For running integration tests, `run-tests.py` script should be used. This
script will iterate over selected cookbooks and run kitchen test on each of
them.

In the simplest scenario, one just needs to run `./run-tests.sh -l test.list`
and script will run tests for all cookbooks that are listed in `test.list`
file.

Testing only a subset of cookbooks is also possible by running `./run-tests.py`
and specifying cookbooks as a parameters.

For more information on what parameters are available, run `./run-tests.py`
with no parameters and read tool documentation.


### Running kitchen during development

In order to relieve developers from maintaining various berkshelf related
files, `setup-test.sh` script can be used to prepare environment for
development.

First thins developer needs to do is make sure cookbook that she/he will be
working on is present in `cookbooks` folder and that it contains `.kitchen.yml`
file and `test` folder with integration tests. We will assume that cookbook we
are working on is named `app`.

To prepare environment for development, we run `./setup-test.sh app`. This will
create some links that will allow kitchen to run tests against local cookbooks.
Now we can run kitchen from root folder as we would from cookbook folder.

Doing development this way makes sure we have all of the cookbooks present in
repository, since kitchen will fail to run if anything is missing. And running
locally is a hard requirement for this repo, since DICE TOSCA library uses
Chef's local mode to install software components.


### Excluding platforms

By default, test runner will perform tests on ubuntu 14.04 and 16.04. If
cookbook does not support both platforms, we can mask desired platforms by
adding `excludes: [ubuntu-16.04]` line to affected test suites.
