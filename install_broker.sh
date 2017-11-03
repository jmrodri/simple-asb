#!/bin/bash
_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

NAMESPACE="ansible-service-broker"

oc login -u system:admin
oc new-project ${NAMESPACE}

VARS="-p BROKER_CA_CERT=$(oc get secret -n kube-service-catalog -o go-template='{{ range .items }}{{ if eq .type "kubernetes.io/service-account-token" }}{{ index .data "service-ca.crt" }}{{end}}{{"\n"}}{{end}}' | tail -n 1)"

oc process -f ${_dir}/deploy-ansible-service-broker.template.yaml \
  -n ${NAMESPACE} $VARS | oc create -f -

if [[ "$?" -ne 0 ]]; then
  echo "Error deploying ansible-service-broker"
  exit
fi
