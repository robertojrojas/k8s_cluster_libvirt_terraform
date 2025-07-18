#!/bin/bash

echo "source <(kubectl completion bash)" >> /root/.bashrc
echo "alias k=kubectl" >> /root/.bashrc
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
echo "source <(helm completion bash)" >> /root/.bashrc

(
  set -x; cd "$(mktemp -d)" &&
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/v0.4.5/krew-linux_amd64.tar.gz" &&
  tar zxvf krew-linux_amd64.tar.gz &&
  export KREW_ROOT="/root/.krew" &&
  ./krew-linux_amd64 install krew
  echo 'export PATH=/root/.krew/bin:$PATH' >> /root/.bashrc
)
kubectl krew index add netshoot https://github.com/nilic/kubectl-netshoot.git
kubectl krew install netshoot/netshoot
kubectl krew install ctx ns
EOF
