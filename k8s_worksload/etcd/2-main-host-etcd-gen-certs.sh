
source ./hosts.sh

kubeadm init phase certs etcd-server --config=./${HOST2}/kubeadmcfg.yaml
kubeadm init phase certs etcd-peer --config=./${HOST2}/kubeadmcfg.yaml
kubeadm init phase certs etcd-healthcheck-client --config=./${HOST2}/kubeadmcfg.yaml
kubeadm init phase certs apiserver-etcd-client --config=./${HOST2}/kubeadmcfg.yaml

rm -rf ./${HOST2}/pki
cp -R /etc/kubernetes/pki ./${HOST2}/

# cleanup non-reusable certificates
find /etc/kubernetes/pki -not -name ca.crt -not -name ca.key -type f -delete

kubeadm init phase certs etcd-server --config=./${HOST1}/kubeadmcfg.yaml
kubeadm init phase certs etcd-peer --config=./${HOST1}/kubeadmcfg.yaml
kubeadm init phase certs etcd-healthcheck-client --config=./${HOST1}/kubeadmcfg.yaml
kubeadm init phase certs apiserver-etcd-client --config=./${HOST1}/kubeadmcfg.yaml

rm -rf ./${HOST1}/pki
cp -R /etc/kubernetes/pki ./${HOST1}/
find /etc/kubernetes/pki -not -name ca.crt -not -name ca.key -type f -delete

kubeadm init phase certs etcd-server --config=./${HOST0}/kubeadmcfg.yaml
kubeadm init phase certs etcd-peer --config=./${HOST0}/kubeadmcfg.yaml
kubeadm init phase certs etcd-healthcheck-client --config=./${HOST0}/kubeadmcfg.yaml
kubeadm init phase certs apiserver-etcd-client --config=./${HOST0}/kubeadmcfg.yaml

rm -rf ./${HOST0}/pki
cp -R /etc/kubernetes/pki ./${HOST0}/
# find /etc/kubernetes/pki -not -name ca.crt -not -name ca.key -type f -delete
