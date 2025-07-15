#!/bin/bash

####################################
####################################
###### KUBEADM CONTROL PLANE #######
######        ROCKY9         #######
####################################
####################################

/usr/local/bin/etc_hosts_extra.sh

sudo dnf update -y

sudo dnf install -y iptables iproute-tc git curl wget

sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

sudo setenforce 0
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config


sudo cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

sudo cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward = 1
EOF

sudo sysctl --system

sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

sudo dnf install containerd.io -y

cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.33/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.33/rpm/repodata/repomd.xml.key
EOF


containerd config default | sudo tee /etc/containerd/config.toml >/dev/null 2>&1
sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml

sudo systemctl restart containerd
sudo systemctl enable containerd
#sudo systemctl status containerd


sudo yum install -y kubelet kubeadm kubectl

sudo systemctl enable kubelet

sudo kubeadm config images pull

sudo mkdir -p /run/systemd/resolve
sudo touch /run/systemd/resolve/resolv.conf


sudo kubeadm init --pod-network-cidr=10.244.0.0/16

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Verify
kubectl cluster-info
echo "Run: kubectl cluster-info dump"

kubectl get nodes   -o wide
kubectl get pods -A -o wide

# CNI Install: flannel
#kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml
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
