#!/bin/bash

set -e

. utils-inc.sh

function usage ()
{
  cat <<EOF
USAGE:

  $0 cookbook

This command will prepare environment for local developemtn od cookbook.
Kitchen commands that would usually be run from cookbook folder should be
called from root of the repo after this call.
EOF
}

# Entry point
[[ "x$1" == "x" ]] && usage && exit 0
clean_env $1
prepare_env $1
