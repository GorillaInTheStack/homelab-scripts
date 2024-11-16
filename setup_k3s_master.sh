#!/bin/bash

echo "Uninstalling K3s on master node..."
/usr/local/bin/k3s-uninstall.sh


echo "Installing K3s on master node with WireGuard as the backend..."
curl -sfL https://get.k3s.io | sh -s - server --cluster-init \
    --flannel-backend=wireguard-native


K3S_TOKEN=$(sudo cat /var/lib/rancher/k3s/server/node-token)
MASTER_IP=$(hostname -I | awk '{print $1}')

# Automatically copy the kubeconfig file to the user's home directory
echo "Setting up kubeconfig for the current user..."
mkdir -p ~/.kube
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
sudo chown $(id -u):$(id -g) ~/.kube/config
chmod 600 ~/.kube/config

# Update PATH for kubectl if necessary
if ! command -v kubectl &> /dev/null; then
    echo "kubectl not found, adding symlink to /usr/local/bin..."
    sudo ln -sf /usr/local/bin/kubectl /usr/bin/kubectl
fi


echo "Master setup complete with WireGuard."
echo "Run the following command on each worker to join the cluster with WireGuard:"
echo "curl -sfL https://get.k3s.io | K3S_URL=https://${MASTER_IP}:6443 K3S_TOKEN=${K3S_TOKEN} sh -"

# Test cluster setup and kubeconfig
echo "Testing kubeconfig..."
kubectl get nodes

