#!/bin/bash
set -eo pipefail

check_vars()
{
    var_names=("$@")
    for var_name in "${var_names[@]}"; do
        [ -z "${!var_name}" ] && echo "Env. var $var_name is unset." && var_unset=true
    done
    [ -n "$var_unset" ] && exit 1
    return 0
}

check_vars KEY_STORE_PASSWORD TRUST_STORE_PASSWORD DATABASE_PASSWORD DATABASE_USER DATABASE_URL

cd /corda/

BASE_DIR="$(pwd)" \
  java -jar corda.jar