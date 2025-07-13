#!/bin/bash

####################################
####################################
######    KUBEADM WORKER     #######
######        FEDORA         #######
####################################
####################################

/usr/local/bin/etc_hosts_extra.sh

sudo dnf update -y

sudo dnf install -y iptables iproute-tc git curl wget

sudo systemctl stop swap-create@zram0
sudo dnf remove zram-generator-defaults -y

sudo systemctl disable --now firewalld


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


sudo dnf install -y cri-o containernetworking-plugins

sudo systemctl enable --now crio

sudo systemctl status crio | strings

sudo dnf install -y kubernetes1.32 kubernetes1.32-kubeadm kubernetes1.32-client

sudo systemctl enable kubelet

sudo kubeadm config images pull
