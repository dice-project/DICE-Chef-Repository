SKIPPED_COOKBOOKS=""
FAILED_COOKBOOKS=""

function log_skip ()
{
  echo "Skipping cookbook $1"
  SKIPPED_COOKBOOKS="$SKIPPED_COOKBOOKS $1"
}

function validate_cookbook_content ()
{
  local cookbook_path=cookbooks/$1

  echo "Validating cookbooks $cookbook ..."
  [[ ! -d $cookbook_path ]] && log_skip $1 && return 1
  [[ ! -d $cookbook_path/test ]] && log_skip $1 && return 1
  [[ ! -f $cookbook_path/.kitchen.yml ]] && log_skip $1 && return 1

  return 0
}

function clean_env ()
{
  echo "Cleaning environment ..."
  rm -f test .kitchen.yml .kitchen
}

function prepare_env ()
{
  local cookbook=$1

  clean_env $cookbook

  echo "Preparing to test $cookbook cookbook ..."
  ln -s cookbooks/$cookbook/test test
  ln -s cookbooks/$cookbook/.kitchen.yml .kitchen.yml
  # This folder might not be present yet, so we create it first (just in case)
  mkdir -p cookbooks/$cookbook/.kitchen
  ln -s cookbooks/$cookbook/.kitchen .kitchen
}

function run_test ()
{
  echo "Testing $1 cookbook ..."
  prepare_env $1
  kitchen test --concurrency=$CONCURRENCY --destroy=$DESTROY_STRATEGY \
    && return 0
  FAILED_COOKBOOKS="$FAILED_COOKBOOKS $1"
}

function exit_with_1_on_failure ()
{
  echo
  echo "# SUMMARY ##################"
  echo "Failed cookbooks: $FAILED_COOKBOOKS"
  echo "Skiped cookbooks: $SKIPPED_COOKBOOKS"
  echo "############################"

  # Fail if any skipping/failing occurred
  [[ "x" != "x$SKIPPED_COOKBOOKS" ]] && exit 1
  [[ "x" != "x$FAILED_COOKBOOKS" ]] && exit 1
  exit 0
}
