#!/bin/bash

export CONT_VERSION=0.1

# Create the Image
docker buildx build --platform linux/amd64 -t quay.io/niklaushirt/ibm-aiops-turbo-topology:$CONT_VERSION --load .
docker push quay.io/niklaushirt/ibm-aiops-turbo-topology:$CONT_VERSION




# Run the Image

docker build -t niklaushirt/ibm-aiops-incident-simulator:$CONT_VERSION  .

docker run -p 8080:8000 -e TOKEN=test niklaushirt/ibm-aiops-incident-simulator:$CONT_VERSION

# Deploy the Image
oc apply -n default -f create-cp4mcm-event-gateway.yaml





exit 1

