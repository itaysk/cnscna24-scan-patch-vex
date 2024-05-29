#! /usr/bin/env bash

## setup
# image needs to be in a registry so it can be referred to by purl
REGISTRY="localhost:5000"
IMAGE="${REGISTRY:+$REGISTRY/}appy"

cleanup() {
    rm -f "$vex"
}
trap cleanup EXIT

## maintainer
# appy is a simple alpine-based image with vulnerabilities
docker build -t "$IMAGE" ./appy
docker push "$IMAGE"
# the conatiner image has HIGH vulnerability in libxml2
trivy image --severity HIGH "$IMAGE"
# appy maintainer determines the libxml2 vulnerability is not applicable to appy and creates a an openvex statement
cat ./appy/.vex/openvex.json
# push vex to registry and refer to image
regctl artifact put --artifact-type example/openvex --subject "$IMAGE" < ./appy/.vex/openvex.json

## user
# find vex in registry
regctl artifact tree "$IMAGE"
regctl artifact list "$IMAGE" --filter-artifact-type example/openvex --latest
# fetch vex from registry
vex=$(mktemp)
regctl artifact get --subject "$IMAGE" --filter-artifact-type example/openvex --latest > "$vex"
# scan with fetched vex
trivy image --severity HIGH --vex "$vex" --show-suppressed "$IMAGE"
