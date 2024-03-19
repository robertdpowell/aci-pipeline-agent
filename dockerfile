FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Install necessary dependencies
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
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Install Docker CLI in case your pipeline needs to build Docker images
RUN apt-get update && apt-get install -y apt-transport-https ca-certificates curl software-properties-common lsb-release \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
    && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
    && apt-get update \
    && apt-get install -y docker-ce-cli \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Add a user for the build agent
RUN useradd -m buildagent

# Set up the Azure DevOps agent
USER buildagent
WORKDIR /home/buildagent

# If you want to always download the latest version, uncomment the following lines:
RUN AGENT_VERSION=$(curl -sL https://api.github.com/repos/microsoft/azure-pipelines-agent/releases/latest | jq -r '.tag_name')

# Copy the start.sh script and ensure it's executable
COPY --chown=buildagent:buildagent start.sh .
RUN chmod +x ./start.sh

# Set the entry point to the start script
CMD ["./start.sh"]
