#!/usr/bin/env bash
set -euxo pipefail

script_path="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

if ! command -v sops &> /dev/null
then
	brew install sops 
fi 

sops --encrypt "$script_path"/.secrets > "$script_path"/.secrets.enc