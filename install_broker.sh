#!/bin/bash
_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# basically what the blog does

oc cluster up --service-catalog=true

oc login -u system:admin
oc new-project ansible-service-broker

VARS="-p BROKER_CA_CERT=$(oc get secret -n kube-service-catalog -o go-template='{{ range .items }}{{ if eq .type "kubernetes.io/service-account-token" }}{{ index .data "service-ca.crt" }}{{end}}{{"\n"}}{{end}}' | tail -n 1)"

oc process -f ${_dir}/deploy-ansible-service-broker.template.yaml \
  -n "ansible-service-broker" $VARS | oc create -f -

if [[ "$?" -ne 0 ]]; then
  echo "Error deploying ansible-service-broker"
  exit
fi
