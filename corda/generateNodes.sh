#!/usr/bin/env bash
set -euxo pipefail

script_path="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
echo "script_path: $script_path"

# downloading network bootstrapper
version="4.9.6"
if [[ ! -f "network-bootstrapper-$version.jar" ]]; then
    curl -o "network-bootstrapper-$version.jar" "https://software.r3.com/artifactory/corda-releases/net/corda/corda-tools-network-bootstrapper/$version/corda-tools-network-bootstrapper-$version.jar"
fi


"$script_path"/decryptSecrets.sh
# loading secrets
# trunk-ignore(shellcheck/SC1091)
set -o +x allexport; source "$script_path/.secrets"; set +o allexport

export KEY_STORE_PASSWORD TRUST_STORE_PASSWORD DATABASE_URL DATABASE_USER DATABASE_PASSWORD DATASOURCE_CLASS_NAME
#rm .secrets

# generating configs for the nodes
echo "this script requires java version 1.8 or 11"
java --version
BASE_DIR="$script_path" \
  java -jar "network-bootstrapper-$version.jar" --dir "$script_path/nodes"


