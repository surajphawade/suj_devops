#!/bin/bash

# Shell script to create a root-like user for sandbox DevOps agent setup

NEW_USER="devopsadmin"

# Ensure root
if [ "$EUID" -ne 0 ]; then
  echo "❌ Please run this script as root (use sudo)"
  exit 1
fi

# Create user
if id "$NEW_USER" &>/dev/null; then
    echo "✅ User $NEW_USER already exists."
else
    useradd -m -s /bin/bash "$NEW_USER"
    echo "➡️ Created user $NEW_USER"
fi

# Set password interactively
echo "🔐 Set a password for $NEW_USER"
passwd "$NEW_USER"

# Add to groups
usermod -aG docker "$NEW_USER"
usermod -aG sudo "$NEW_USER"
usermod -g 0 "$NEW_USER"   # root group
usermod -u 0 "$NEW_USER"   # root UID

# Copy root environment
cp -r /root/.bashrc /root/.profile /home/$NEW_USER/
chown -R "$NEW_USER:$NEW_USER" /home/$NEW_USER/

# Fix docker socket permission (optional)
chmod 660 /var/run/docker.sock
chown root:docker /var/run/docker.sock

echo "✅ Root-like user $NEW_USER is ready. Switch using: su - $NEW_USER"
