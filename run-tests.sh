#!/bin/bash

set -e

. utils-inc.sh

CONCURRENCY=${KITCHEN_CONCURRENCY:-1}
DESTROY_STRATEGY=${KITCHEN_DESTROY_STRATEGY:-always}


function usage ()
{
  cat <<EOF
USAGE:

  $0 [cookbook [...] | all]

This command will run integration test for selected cookbooks. Special value
"all" can be used to run test on all testable cookbooks.

Available cookbooks: $COOKBOOKS

Environment variables that control kitchen execution:

  KITCHEN_CONCURRENCY: Number of tests to run in parallel (default: 1)
  KITCHEN_DESTROY_STRATEGY: Cleanup action to perform (default: always)

Note that this script expects that any driver specific settings are already
present in ".kitchen.local.yml" file.
EOF
}

function run_tests ()
{
  while [[ "x$1" != "x" ]]
  do
    validate_cookbook_content $1 && run_test $1
    shift
  done
}


# Argument checking
if [[ "x$1" == "x" ]]
then
  usage
  exit 0
fi

# Prepare cookbooks
if [[ "$1" == "all" ]]
then
  test_list=$(cat test.list)
else
  test_list=$@
fi

# Main test runner
run_tests $test_list
exit_with_1_on_failure
