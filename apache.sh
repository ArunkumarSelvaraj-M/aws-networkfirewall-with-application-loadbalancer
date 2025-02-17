#!/bin/bash

# Update package list
echo "Updating package list..."
sudo apt update -y || sudo yum update -y

# Install Apache
echo "Installing Apache HTTP Server..."
if command -v apt > /dev/null; then
    sudo apt install -y apache2
    sudo systemctl enable apache2
    sudo systemctl start apache2
elif command -v yum > /dev/null; then
    sudo yum install -y httpd
    sudo systemctl enable httpd
    sudo systemctl start httpd
else
    echo "Unsupported package manager. Exiting."
    exit 1
fi

# Check status
echo "Checking HTTP server status..."
sudo systemctl status apache2 || sudo systemctl status httpd

echo "Apache HTTP Server installation complete."
