#!/bin/bash

git clone https://github.com/niklaushirt/ibm-aiops-eda.git
cd ibm-aiops-eda/container/


export CONT_VERSION=0.1
docker build -t niklaushirt/eda-container:$CONT_VERSION .
docker push niklaushirt/eda-container:$CONT_VERSION



exit 1
docker run -ti --rm -p 5000:5000 niklaushirt/eda-container:$CONT_VERSION /bin/bash
ansible-rulebook --rulebook ./rulebooks/default-rulebook.yaml -i inventory.yaml --verbose




export CONT_VERSION=2.0

# Build Production AMD64
docker buildx build --platform linux/amd64 -t niklaushirt/ibm-aiops-tools:$CONT_VERSION --load .




docker push niklaushirt/ibm-aiops-tools:$CONT_VERSION



docker build -t test:0.1 .
docker run -ti --rm -p 5000:5000 test:0.1 /bin/bash
ansible-rulebook --rulebook ./rulebooks/default-rulebook.yaml -i inventory.yaml --verbose



cd ..
cd ..
sudo rm -r ibm-aiops-eda
git clone https://github.com/niklaushirt/ibm-aiops-eda.git
cd ibm-aiops-eda/BUILD/

export CONT_VERSION=0.1
docker build -t niklaushirt/eda-container:$CONT_VERSION .
docker push niklaushirt/eda-container:$CONT_VERSION
