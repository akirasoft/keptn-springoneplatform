FROM docker:17.12.0-ce as static-docker-source
FROM alpine:3.7

# Install tools:
RUN apk add --update --no-cache \
    bash \
    bc \
    ca-certificates \
    curl \
    git \
    gnupg \
    jq \
    wget \
    vim 

ARG YQ_VERSION=2.3.0
RUN wget -q https://github.com/mikefarah/yq/releases/download/$YQ_VERSION/yq_linux_amd64 -O /bin/yq && \
  chmod +x /bin/yq
RUN yq --version

ARG HELM_VERSION=2.12.3
RUN wget -q https://storage.googleapis.com/kubernetes-helm/helm-v$HELM_VERSION-linux-amd64.tar.gz && \
  tar -zxvf helm-v$HELM_VERSION-linux-amd64.tar.gz && \
  mv linux-amd64/helm /bin/helm && \
  rm -f helm-v$HELM_VERSION-linux-amd64.tar.gz && \
  rm -rf linux-amd64

ARG KUBE_VERSION=1.14.1
RUN wget -q https://storage.googleapis.com/kubernetes-release/release/v$KUBE_VERSION/bin/linux/amd64/kubectl -O /bin/kubectl && \
  chmod +x /bin/kubectl

ARG OC_VERSION=3.11.0
RUN wget -q https://github.com/openshift/origin/releases/download/v3.11.0/openshift-origin-client-tools-v$OC_VERSION-0cbc58b-linux-64bit.tar.gz && \ 
  tar xzvf openshift*tar.gz && \
  cp openshift-origin-client-tools-*/oc /bin/oc && \
  rm -f openshift*tar.gz && \
  rm -rf openshift-origin-client-tools-*

# install gcloud sdk for alpine
ARG CLOUD_SDK_VERSION=267.0.0
ENV CLOUD_SDK_VERSION=$CLOUD_SDK_VERSION
ENV PATH /google-cloud-sdk/bin:$PATH
COPY --from=static-docker-source /usr/local/bin/docker /usr/local/bin/docker
RUN apk --no-cache add \
        curl \
        python \
        py-crcmod \
        bash \
        libc6-compat \
        openssh-client \
        git \
        gnupg \
    && curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    tar xzf google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    rm google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    gcloud config set core/disable_usage_reporting true && \
    gcloud config set component_manager/disable_update_check true && \
    gcloud config set metrics/environment github_docker_image && \
    gcloud --version

# install azure cli for alpine

#RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

ARG KEPTN_VERSION="0.5.0"
ARG DISTR=linux
RUN curl -L "https://github.com/keptn/keptn/releases/download/${KEPTN_VERSION}/${KEPTN_VERSION}_keptn-${DISTR}.tar" --output keptn-install-${KEPTN_VERSION}.tar && \
  tar -C /tmp -xvf keptn-install-${KEPTN_VERSION}.tar && \
  rm keptn-install-${KEPTN_VERSION}.tar && \
  chmod +x /tmp/keptn && \
  mv /tmp/keptn /usr/local/bin/keptn

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
