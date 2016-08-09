# Testing of Chef cookbooks

Testing of Chef cookbooks locally (that is, without berks getting in a way and
downloading stuff from 3rd party sites) is science in itself. In order to ease
the burden for developers, there are two helper scripts present in this
repository.


## Running integration tests

For running integration tests, `run-tests.sh` script should be used. This
script will iterate over selected cookbooks and run kitchen test on each of
them.

In the simplest scenario, one just needs to run `./run-tests.sh all` and script
will run tests for all cookbooks that are listed in `test.list` file.

Testing only a subset of cookbooks is also possible by running `./run-tests.sh`
and specifying cookbooks as a parameters.

Test runner is capable of running tests in parallel. In order to activate this
feature, simply set `KITCHEN_CONCURRENCY` environment variable to something
other that default value of 1. What kitchen does on failure is another
customizable aspect of test runner. This can be controlled by settings
`KITCHEN_DESTROY_STRATEGY` environment variable. Default action is to always
destroy virtual machines (for the sake of integration testing), but you can
specify any value here that is valid for kitchen's `--destroy` option.


## Running kitchen during development

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
