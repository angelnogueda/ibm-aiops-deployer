FROM ubuntu:22.10

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
  git \
  wget \
  jq \
  curl \
  && rm -rf /var/lib/apt/lists/*

# Install Openshift Client
RUN wget https://github.com/openshift/okd/releases/download/4.9.0-0.okd-2022-01-14-230113/openshift-client-linux-4.9.0-0.okd-2022-01-14-230113.tar.gz && tar xfvz openshift-client-linux-4.9.0-0.okd-2022-01-14-230113.tar.gz && mv oc /usr/local/bin && mv kubectl /usr/local/bin/ && rm openshift-client-linux-4.9.0-0.okd-2022-01-14-230113.tar.gz


WORKDIR /ibm-aiops


COPY startup.sh /ibm-aiops/startup.sh
RUN chmod +x /ibm-aiops/startup.sh

ENTRYPOINT /ibm-aiops/startup.sh
