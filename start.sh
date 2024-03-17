#!/bin/bash
set -e

# Check if the necessary environment variables are set
if [ -z "$AZDO_URL" ] || [ -z "$AZDO_PAT" ] || [ -z "$AZDO_POOL" ]; then
    echo "One or more required environment variables are missing."
    exit 1
fi

echo "Configuring Azure DevOps Agent..."

# Use the environment variables to configure the Azure DevOps Agent
./config.sh --unattended \
  --agent "$(hostname)" \
  --url "https://dev.azure.com/$AZDO_URL" \
  --auth pat \
  --token "$AZDO_PAT" \
  --pool "$AZDO_POOL" \
  --replace \
  --work "_work"

# Start the agent
echo "Starting Azure DevOps Agent..."
./run.sh
