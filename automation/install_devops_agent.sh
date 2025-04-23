#!/bin/bash

# --- Configuration Variables ---
ORG_URL="https://dev.azure.com/YOUR_ORG"
AGENT_POOL="Default"
AGENT_NAME="sandbox-agent-$(hostname)"
PAT="YOUR_PERSONAL_ACCESS_TOKEN"

# Agent install location
AGENT_DIR="/home/devopsadmin/myagent"

# Check user
if [ "$EUID" -ne 0 ]; then
  echo "Run this script as root"
  exit 1
fi

# Create agent directory
mkdir -p "$AGENT_DIR"
cd "$AGENT_DIR"

# Download agent package
curl -Ls https://vstsagentpackage.azureedge.net/agent/3.234.0/vsts-agent-linux-x64-3.234.0.tar.gz | tar -xz

# Give permissions to user
chown -R devopsadmin:devopsadmin "$AGENT_DIR"

# Switch to new user and configure agent
su - devopsadmin -c "
  cd $AGENT_DIR &&
  ./config.sh --unattended \
              --url $ORG_URL \
              --auth pat \
              --token $PAT \
              --pool $AGENT_POOL \
              --agent $AGENT_NAME \
              --acceptTeeEula \
              --replace &&
  sudo ./svc.sh install devopsadmin &&
  sudo ./svc.sh start
"

echo "✅ Azure DevOps Agent installed and running as devopsadmin"
