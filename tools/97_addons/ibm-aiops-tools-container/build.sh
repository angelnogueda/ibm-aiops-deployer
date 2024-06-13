#!/bin/bash


podman machine start

podman login quay.io -u niklaushirt@gmail.com


export CONT_VERSION=2.2

podman buildx build --platform linux/amd64 -t quay.io/niklaushirt/ibm-aiops-tools:$CONT_VERSION --load .
podman push quay.io/niklaushirt/ibm-aiops-tools:$CONT_VERSION




export CONT_VERSION=2.0

# Build Production AMD64
docker buildx build --platform linux/amd64 -t quay.io/niklaushirt/ibm-aiops-tools:$CONT_VERSION --load .
docker push quay.io/niklaushirt/ibm-aiops-tools:$CONT_VERSION

podman tag quay.io/niklaushirt/ibm-aiops-tools:2.2 quay.io/niklaushirt/ibm-aiops-tools:2.2
podman push quay.io/niklaushirt/ibm-aiops-tools:2.2
