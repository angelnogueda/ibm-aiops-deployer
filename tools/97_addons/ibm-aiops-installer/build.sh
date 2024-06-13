#!/bin/bash

export CONT_VERSION=2.0


# Build Production AMD64
docker buildx build --platform linux/amd64 -t quay.io/niklaushirt/ibm-aiops-installer:$CONT_VERSION --load .
docker push quay.io/niklaushirt/ibm-aiops-installer:$CONT_VERSION




# Local Test Mac
docker build -t niklaushirt/ibm-aiops-installer:arm$CONT_VERSION .
#sudo docker push ibm-aiops-install:arm$CONT_VERSION
docker run -p 8080:8080 niklaushirt/ibm-aiops-installer:arm$CONT_VERSION
