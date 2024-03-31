FROM ubuntu:22.04

RUN apt update -y && apt upgrade -y && apt install curl git jq libicu70 -y

# Install Java (OpenJDK 11 in this example)
RUN apt install -y openjdk-17-jdk

# Verify Java installation
RUN java -version && javac -version

# Set JAVA_HOME for OpenJDK 17
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64

# Ensure JAVA_HOME is in the PATH
ENV PATH="${JAVA_HOME}/bin:${PATH}"

# Also can be "linux-arm", "linux-arm64".
ENV TARGETARCH="linux-x64"

WORKDIR /azp/

COPY ./start.sh ./
RUN chmod +x ./start.sh

# Create agent user and set up home directory
RUN useradd -m -d /home/agent agent
RUN chown -R agent:agent /azp /home/agent

USER agent
# Another option is to run the agent as root.
# ENV AGENT_ALLOW_RUNASROOT="true"

ENTRYPOINT ./start.sh
