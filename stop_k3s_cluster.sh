#!/bin/bash

echo "Stopping k3s on master (babylon)..."
sudo systemctl stop k3s

echo "Stopping k3s on worker nodes..."
ssh sam@laptop "sudo systemctl stop k3s-agent"
ssh sam@ubuntu-vm "sudo systemctl stop k3s-agent"

echo "Cluster stopped successfully!"
