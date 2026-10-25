#!/bin/sh

# Install Anaconda
wget https://repo.anaconda.com/archive/Anaconda3-2026.07-1-Linux-x86_64.sh
bash Anaconda3-2026.07-1-Linux-x86_64.sh -b -p /opt/anaconda3
rm Anaconda3-2026.07-1-Linux-x86_64.sh

# Update package lists and install basic prerequisites
apt-get update
apt-get install -y ca-certificates curl

# Set up Docker GPG key
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker packages
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Setup the docker group and add the user
groupadd -f docker
usermod -aG docker "$USER"

# Initialize conda for the user's bash profile
/opt/anaconda3/bin/conda init