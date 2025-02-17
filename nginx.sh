#!/bin/bash

# Update package list
echo "Updating package list..."
sudo apt update -y || sudo yum update -y

# Install Nginx
echo "Installing Nginx..."
if command -v apt > /dev/null; then
    sudo apt install -y nginx
    sudo systemctl enable nginx
    sudo systemctl start nginx
elif command -v yum > /dev/null; then
    sudo yum install -y nginx
    sudo systemctl enable nginx
    sudo systemctl start nginx
else
    echo "Unsupported package manager. Exiting."
    exit 1
fi

# Check status
echo "Checking Nginx server status..."
sudo systemctl status nginx

echo "Nginx installation complete."
