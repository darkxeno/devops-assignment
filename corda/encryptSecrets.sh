#!/usr/bin/env bash
set -euxo pipefail

if ! command -v sops &> /dev/null
then
	brew install sops 
fi 

sops --encrypt .secrets > .secrets.enc