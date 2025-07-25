#!/usr/bin/bash

####################################
####################################
###### KUBEADM CONTROL PLANE #######
######        UBUNTU         #######
####################################
####################################

/usr/local/bin/etc_hosts_extra.sh

# # Open the necessary ports on the CP's (control-plane node) firewall.
# sudo ufw allow 6443/tcp
# sudo ufw allow 2379:2380/tcp
# sudo ufw allow 10250/tcp
# sudo ufw allow 10259/tcp
# sudo ufw allow 10257/tcp

# # Get status
# sudo ufw status

sudo systemctl stop ufw

# Disable Swap
sudo swapoff -a
sudo sed -i 's/^swap/#swap/' /etc/fstab

# Always load on boot the k8s modules needed.
sudo tee /etc/modules-load.d/kubernetes.conf <<EOF
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# Verify
sudo lsmod | grep -E 'netfilter|overlay'

# Enable network forwarding !
sudo tee /etc/sysctl.d/kubernetes.conf <<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

sudo sysctl --system

# Setup CRI
curl -sL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/docker-keyring.gpg
sudo chmod 0644 /etc/apt/trusted.gpg.d/docker-keyring.gpg

sudo apt-add-repository -y "deb https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

sleep 1

sudo apt-get -y install containerd.io

containerd config default                              \
 | sed 's/SystemdCgroup = false/SystemdCgroup = true/' \
 | sudo tee /etc/containerd/config.toml

sudo systemctl restart containerd.service

# Install kubeadm
#VERSION=$(curl -s https://api.github.com/repos/kubernetes/kubernetes/releases/latest | jq -r '.tag_name')
VERSION="v1.33.2"
VERSION=${VERSION%.*}

curl -fsSL "https://pkgs.k8s.io/core:/stable:/${VERSION}/deb/Release.key" | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# allow unprivileged APT programs to read this keyring
sudo chmod 0644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# This overwrites any existing configuration in /etc/apt/sources.list.d/kubernetes.list
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/${VERSION}/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list

# helps tools such as command-not-found to work correctly
sudo chmod 0644 /etc/apt/sources.list.d/kubernetes.list

sleep 1

sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl

# Get images
sudo kubeadm config images pull

# Init kubernetes
sudo kubeadm init --pod-network-cidr=10.244.0.0/16

# Setup kubeconfig
KUBEDIR="$HOME/.kube"
rm -rf   "${KUBEDIR}"
mkdir -p "${KUBEDIR}"

sudo cp -i /etc/kubernetes/admin.conf "${KUBEDIR}/config"

sudo chown "$(id -u)":"$(id -g)" "${KUBEDIR}/config"

ls -la "${KUBEDIR}/config"

echo 'alias k="kubectl"' | sudo tee -a /etc/bash.bashrc
source /etc/bash.bashrc

# Verify
kubectl cluster-info
echo "Run: kubectl cluster-info dump"

kubectl get nodes   -o wide
kubectl get pods -A -o wide

# CNI Install: flannel
# kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

# Get k8s cluster join command for worker nodes.
echo ""
echo "Run this command to the workers node to join the cluster:"
sudo kubeadm token create --print-join-command
echo ""
echo ""

sudo tee /usr/local/bin/setup_kubectl.sh<<EOF

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
alias k=kubectl
EOF
chmod +x /usr/local/bin/setup_kubectl.sh 
