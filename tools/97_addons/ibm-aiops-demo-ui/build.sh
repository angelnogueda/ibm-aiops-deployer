#!/bin/bash
podman machine start

podman login quay.io -u niklaushirt@gmail.com
export CONT_VERSION=3.3

export CONT_VERSION=4.5


podman buildx build --platform linux/amd64 -t quay.io/niklaushirt/ibm-aiops-demo-ui:$CONT_VERSION --load -f=Containerfile_small
podman push quay.io/niklaushirt/ibm-aiops-demo-ui:$CONT_VERSION





export CONT_VERSION=3.1

podman buildx build --platform linux/amd64 -t quay.io/niklaushirt/ibm-aiops-demo-ui:$CONT_VERSION --load .
podman push quay.io/niklaushirt/ibm-aiops-demo-ui:$CONT_VERSION



podman buildx build --platform linux/amd64 -t quay.io/niklaushirt/ibm-aiops-demo-ui:$CONT_VERSION --load -f=Containerfile_small



podman buildx build --platform linux/amd64 -t quay.io/niklaushirt/test:01 --load -f=Containerfile_small
podman push quay.io/niklaushirt/test:01

podman images



http://127.0.0.1:8000/injectRESTHeadless?app=clean


podman buildx build --platform linux/amd64 -t test --load .



# Create the Image
docker buildx build --platform linux/amd64 -t quay.io/niklaushirt/ibm-aiops-demo-ui:$CONT_VERSION --load .
docker push quay.io/niklaushirt/ibm-aiops-demo-ui:$CONT_VERSION




export CONT_VERSION=2.0

# Create the Image
podman buildx build --platform linux/amd64 -t quay.io/niklaushirt/ibm-aiops-demo-ui:$CONT_VERSION --load .
docker push quay.io/niklaushirt/ibm-aiops-demo-ui:$CONT_VERSION






export CONT_VERSION=1.20

# Create the Image
docker buildx build --platform linux/amd64 -t niklaushirt/ibm-aiops-demo-ui:$CONT_VERSION --load .
docker push niklaushirt/ibm-aiops-demo-ui:$CONT_VERSION






# Run the Image

docker build -t niklaushirt/ibm-aiops-demo-ui-python:$CONT_VERSION  .

docker run -p 8080:8000 -e TOKEN=test niklaushirt/ibm-aiops-demo-ui-python:$CONT_VERSION

# Deploy the Image
oc apply -n default -f create-cp4mcm-event-gateway.yaml





exit 1


export CONT_VERSION=0.97

# Create the Image
docker build -t niklaushirt/ibm-aiops-demo-ui:$CONT_VERSION .

podman login docker.io -u niklaushirt   
podman build -t niklaushirt/ibm-aiops-demo-ui:$CONT_VERSION .
podman push ^niklaushirt/ibm-aiops-demo-ui:$CONT_VERSION



podman machine start

export CONT_VERSION=0.45

# Create the Image
podman buildx build --platform linux/amd64 -t niklaushirt/ibm-aiops-demo-ui-python:$CONT_VERSION --load .
docker push niklaushirt/ibm-aiops-demo-ui-python:$CONT_VERSION
