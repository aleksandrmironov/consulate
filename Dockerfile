FROM golang:1.9.3


# This is the release of Vault to pull in.
ENV CONSUL_VERSION=0.7.2

# Install debian deps
RUN apt-get update && apt-get install -y \
  curl \
  unzip \
  jq \
  awscli &&\
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* *.gz


# Install consul and vault
RUN curl -L -o ./consul.zip https://releases.hashicorp.com/envconsul/${CONSUL_VERSION}/envconsul_${CONSUL_VERSION}_linux_amd64.zip && \
  unzip -d /usr/bin ./consul.zip && \
  rm *.zip


# Build consulate
RUN mkdir -p $GOPATH/src/github.com/kadaan && \
    cd $GOPATH/src/github.com/kadaan && \
    git clone https://github.com/kadaan/consulate.git && \
    cd consulate && \
    ./build.sh && \
    rm -rf $GOPATH/src/github.com

# Copy consulate to a bin directory
RUN mv $GOPATH/bin/consulate /usr/bin

# add entrypoint
ADD entrypoint.sh /
RUN chmod +x /entrypoint.sh

USER nobody

ENTRYPOINT [ "/entrypoint.sh" ]