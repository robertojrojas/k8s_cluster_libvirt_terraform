# Update HOST0, HOST1 and HOST2 with the IPs of your hosts
export HOST0=192.168.100.221
export HOST1=192.168.100.222
export HOST2=192.168.100.223

# Update NAME0, NAME1 and NAME2 with the hostnames of your hosts
export NAME0="etcd1"
export NAME1="etcd2"
export NAME2="etcd3"

export ETCD_RESOURCES_DIR=/shared/etcd
export HOSTS=(${HOST0} ${HOST1} ${HOST2})
