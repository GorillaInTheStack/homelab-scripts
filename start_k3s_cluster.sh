#!/bin/bash

echo "Starting k3s on master (babylon)..."
sudo systemctl start k3s

echo "Starting k3s on worker nodes..."
ssh sam@laptop "sudo systemctl start k3s-agent"
ssh sam@ubuntu-vm "sudo systemctl start k3s-agent"

echo "Cluster started successfully!"
