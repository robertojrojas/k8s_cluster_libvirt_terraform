source ./hosts.sh

for host in "${!HOSTS[@]}"; do
HOST=${HOSTS[$host]}
  echo "Checking TLS for ${HOST}"
  openssl x509 -in ${HOST}/pki/etcd/peer.crt  -noout -subject  -ext subjectAltName
done