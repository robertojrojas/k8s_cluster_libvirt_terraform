export ETCD_VER=v3.6.4

# choose either URL
GOOGLE_URL=https://storage.googleapis.com/etcd
GITHUB_URL=https://github.com/etcd-io/etcd/releases/download
DOWNLOAD_URL=${GOOGLE_URL}
export ETCD_BIN=./etcd-bin

mkdir -p ${ETCD_BIN}

echo "Downloading ETCD_VER=${ETCD_VER}"
curl -L ${DOWNLOAD_URL}/${ETCD_VER}/etcd-${ETCD_VER}-linux-amd64.tar.gz -o /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz
tar xzvf /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz -C ${ETCD_BIN} --strip-components=1 --no-same-owner
rm -f /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz
