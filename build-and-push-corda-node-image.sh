#!/usr/bin/env bash
set -euo pipefail

script_path="$(
	cd -- "$(dirname "$0")" >/dev/null 2>&1
	pwd -P
)"

docker compose up -d db

"$script_path"/corda/generateNodes.sh

docker compose stop db

docker compose build corda-notary-node

current_commit="$(git rev-parse --short HEAD)"

docker buildx build --platform=linux/amd64 \
	-t cordaacr.azurecr.io/corda-notary-node:"$current_commit" \
	-t cordaacr.azurecr.io/corda-notary-node:latest \
	.

az acr login --name cordaACR

docker push cordaacr.azurecr.io/corda-notary-node:"$current_commit"
docker push cordaacr.azurecr.io/corda-notary-node:latest
