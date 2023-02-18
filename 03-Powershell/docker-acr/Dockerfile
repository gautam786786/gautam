## pin to a specific version because 'latest' currently fails when we try to install the ruby dependencies
#FROM hashicorp/packer:1.6.5

FROM python:3.9-slim

RUN apt-get -y update && \
    apt-get -y install --no-install-recommends \
    software-properties-common \
    lsb-release \
    curl \
    gnupg2 && \
    curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - && \
    apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" && \
    apt-get -y update && apt-get -y install --no-install-recommends \
    bash \
    gcc \
    git \
    libffi-dev \
    musl-dev \
    openssh-client \
    ruby \
    ruby-io-console \
    ruby-dev \
    zip \
    ruby-etc \
    ruby-webrick \
    packer=1.7.6
  # && rm -rf /var/lib/apt/lists/*

# Install ansible from pip so we have the latest (python3 compatible!) version & create somewhere on the image to store the roles
RUN pip3 install --no-cache-dir ansible && mkdir -p /opt/ansible_roles
RUN pip3 install --no-cache-dir pywinrm>=0.2.2

# Install jmespath from pip so we have the latest (python3 compatible!) version whih is a dependency for json_query
RUN pip3 install --no-cache-dir jmespath

# RUN gem install bigdecimal --no-document

# # Install the inspec rubygem
# #RUN gem sources --add http://rubygems.org/
# RUN gem install -p --no-document inspec && gem install -p --no-document inspec-bin

ENV USER=packer_user
ENV UID=1001
ENV GID=1001

RUN adduser \
    --disabled-password \
    --gecos "" \
    --uid "$UID" \
    "$USER"

USER packer_user

ENTRYPOINT ["/bin/bash"]