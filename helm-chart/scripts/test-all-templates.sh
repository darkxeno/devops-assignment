#!/bin/bash
set -eo pipefail

if ! command -v kubeconform &> /dev/null
then
	brew install kubeconform 
fi 

if [ "$1" == "score" ]; then
	if ! command -v kube-score &> /dev/null
	then
		brew install kube-score 
	fi
fi

APPS=("corda-app")


for app in ${APPS[@]};
do
	echo "=================="
	echo " template $app"
	echo "=================="
	helm --debug template . --name-template app \
	  -f ../../envs/common/values-common.yaml \
	  -f ../../envs/dev/$app/values-feature-flags.yaml \
	  -f ../../envs/dev/$app/values-settings.yaml \
	  -f ../../envs/dev/$app/values-terraform.yaml \
	  -f ../../envs/dev/$app/values-version.yaml \
	  -f ../../envs/dev/$app/values-migration-job-version.yaml
done

for app in ${APPS[@]};
do
	echo "=================="
	echo " kubeval $app"
	echo "=================="
	helm template . --name-template app \
	  -f ../../envs/common/values-common.yaml \
	  -f ../../envs/dev/$app/values-feature-flags.yaml \
	  -f ../../envs/dev/$app/values-settings.yaml \
	  -f ../../envs/dev/$app/values-terraform.yaml \
	  -f ../../envs/dev/$app/values-version.yaml \
	  -f ../../envs/dev/$app/values-migration-job-version.yaml | kubeconform -kubernetes-version 1.23.12 -strict
done

if [ "$1" == "score" ]; then
	for app in ${APPS[@]};
	do
		echo "=================="
		echo " kube-score $app"
		echo "=================="
		helm template . --name-template app \
		  -f ../../envs/common/values-common.yaml \
		  -f ../../envs/dev/$app/values-feature-flags.yaml \
		  -f ../../envs/dev/$app/values-settings.yaml \
		  -f ../../envs/dev/$app/values-terraform.yaml \
		  -f ../../envs/dev/$app/values-version.yaml \
		  -f ../../envs/dev/$app/values-migration-job-version.yaml | kube-score score - || true 
	done
fi	








