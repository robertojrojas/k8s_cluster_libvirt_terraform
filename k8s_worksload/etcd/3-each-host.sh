
cd `hostname -I`
cp -r ./pki /etc/kubernetes/
kubeadm init phase etcd local --config=./kubeadmcfg.yaml