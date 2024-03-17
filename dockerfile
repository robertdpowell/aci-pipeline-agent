FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    jq \
    git \
    iputils-ping \
    libcurl4 \
    libicu66 \
    libunwind8 \
    netcat \
    libssl1.1 \
    wget \
    zip \
    unzip \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Install Docker CLI in case your pipeline needs to build Docker images
RUN apt-get update && apt-get install -y apt-transport-https ca-certificates curl software-properties-common lsb-release && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && \
    apt-get update && apt-get install -y docker-ce-cli

# Cleanup
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Add a user for the build agent and switch to it
RUN useradd -m buildagent
USER buildagent
WORKDIR /home/buildagent

# Download and install the Azure DevOps Agent
RUN curl -O https://vstsagentpackage.azureedge.net/agent/2.195.0/vsts-agent-linux-x64-2.195.0.tar.gz && \
    mkdir myagent && \
    cd myagent && \
    tar zxvf ../vsts-agent-linux-x64-2.195.0.tar.gz && \
    rm ../vsts-agent-linux-x64-2.195.0.tar.gz

COPY --chown=buildagent:buildagent start.sh .
RUN chmod +x start.sh
CMD ["./start.sh"]


