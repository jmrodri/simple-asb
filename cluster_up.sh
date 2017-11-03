#!/bin/bash
_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

OC_BIN=$HOME/bin/oc
DOCKER_IP="$(ip addr show docker0 | grep -Po 'inet \K[\d.]+')"
PUBLIC_IP=${PUBLIC_IP:-$DOCKER_IP}
HOSTNAME=${PUBLIC_IP}.nip.io
ROUTING_SUFFIX="${HOSTNAME}"
ORIGIN_IMAGE=${ORIGIN_IMAGE:-"docker.io/openshift/origin"}
ORIGIN_VERSION=${ORIGIN_VERSION:-"latest"}

${OC_BIN} cluster up --image=${ORIGIN_IMAGE} \
    --version=${ORIGIN_VERSION} \
    --service-catalog=true \
    --routing-suffix=${ROUTING_SUFFIX} \
    --public-hostname=${HOSTNAME}
