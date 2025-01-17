FROM ubuntu:18.04

ENV KEPTN_INSTALL_ENV "cluster"
# Install tools:
RUN apt-get update -qq && \
  apt-get install -qqy --no-install-recommends \
    apt-transport-https \
    bc \
    ca-certificates \
    curl \
    git \
    gnupg \
    jq \
    wget \
    vim \
  && rm -rf /var/lib/apt/lists/*

ARG YQ_VERSION=2.3.0
RUN wget -q https://github.com/mikefarah/yq/releases/download/$YQ_VERSION/yq_linux_amd64 -O /bin/yq && \
  chmod +x /bin/yq
RUN yq --version

ARG HELM_VERSION=2.12.3
RUN wget -q https://storage.googleapis.com/kubernetes-helm/helm-v$HELM_VERSION-linux-amd64.tar.gz && \
  tar -zxvf helm-v$HELM_VERSION-linux-amd64.tar.gz && \
  mv linux-amd64/helm /bin/helm && \
  rm -f helm-v$HELM_VERSION-linux-amd64.tar.gz && \
  rm -rf linux-amd6

ARG KUBE_VERSION=1.14.1
RUN wget -q https://storage.googleapis.com/kubernetes-release/release/v$KUBE_VERSION/bin/linux/amd64/kubectl -O /bin/kubectl && \
  chmod +x /bin/kubectl

ARG OC_VERSION=3.11.0
RUN wget -q https://github.com/openshift/origin/releases/download/v3.11.0/openshift-origin-client-tools-v$OC_VERSION-0cbc58b-linux-64bit.tar.gz && \ 
  tar xzvf openshift*tar.gz && \
  cp openshift-origin-client-tools-*/oc /bin/oc && \
  rm -f openshift*tar.gz && \
  rm -rf openshift-origin-client-tools-*

RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
RUN apt-get update -qq && apt-get install -qqy google-cloud-sdk --no-install-recommends && rm -rf /var/lib/apt/lists/*

RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

RUN curl -sL https://get.keptn.sh | bash

WORKDIR /usr/keptn
COPY . /usr/keptn/scripts
COPY ./bin/pks /usr/local/bin/pks

RUN git clone https://github.com/akirasoft/keptn-springoneplatform.git
#RUN git clone --branch keptn-0.5.0 https://github.com/jetzlstorfer/keptn-springoneplatform.git --single-branch

# get the dynatrace service with PKS support
RUN git clone --branch release-0.3.1 https://github.com/keptn-contrib/dynatrace-service --single-branch

# get the examples folder
RUN git clone --branch 0.5.0 https://github.com/keptn/examples.git --single-branch

# Start the app
CMD tail -f /dev/null
