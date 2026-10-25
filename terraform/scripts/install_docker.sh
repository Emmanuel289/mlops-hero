#!/bin/sh

# 1. Download Anaconda
wget https://repo.anaconda.com/archive/Anaconda3-2022.05-Linux-x86_64.sh

# 2. Run Anaconda in non-interactive BATCH mode (-b) 
# This automatically accepts the license terms and installs to /opt/anaconda3
bash Anaconda3-2022.05-Linux-x86_64.sh -b -p /opt/anaconda3

# 3. Update package lists and install basic prerequisites
apt-get update
apt-get install -y ca-certificates curl

# 4. Set up Docker GPG key
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# 5. Add the repository to Apt sources
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

# 6. Re-update and install Docker packages without prompting (-y)
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# 7. Setup the docker group
groupadd -f docker

# 8. Add any specific users to the docker group if needed
# Note: $USER inside a startup script evaluates to 'root', so if you have a 
# custom user account, explicitly add them here:
usermod -aG docker $USER
