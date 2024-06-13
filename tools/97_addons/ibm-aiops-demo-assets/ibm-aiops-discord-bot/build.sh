#!/bin/bash



podman machine start

podman login quay.io -u niklaushirt@gmail.com


export CONT_VERSION=2.0

podman buildx build --platform linux/amd64 -t quay.io/niklaushirt/ibm-aiops-discord-bot:$CONT_VERSION --load -f=Containerfile
podman push quay.io/niklaushirt/ibm-aiops-discord-bot:$CONT_VERSION









export CONT_VERSION=1.0

# Create the Image
docker buildx build --platform linux/amd64 -t quay.io/niklaushirt/ibm-aiops-discord-bot:$CONT_VERSION --load .
docker push quay.io/niklaushirt/ibm-aiops-discord-bot:$CONT_VERSION

# Run the Image

docker build -t niklaushirt/ibm-aiops-demo-bot:$CONT_VERSION  .

docker run -p 8080:8000 -e TOKEN=test niklaushirt/ibm-aiops-demo-bot:$CONT_VERSION

# Deploy the Image
oc apply -n default -f create-cp4mcm-event-gateway.yaml





exit 1

