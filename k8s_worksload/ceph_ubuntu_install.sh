#!/bin/bash

### Create 3 Disks ###

# sudo qemu-img create -f qcow2 /var/lib/libvirt/images/storage-ubuntu-focal-4_vdb_storage 20G
# sudo qemu-img create -f qcow2 /var/lib/libvirt/images/storage-ubuntu-focal-4_vdc_storage 20G
# sudo qemu-img create -f qcow2 /var/lib/libvirt/images/storage-ubuntu-focal-4_vdd_storage 20G

# sudo virsh attach-disk storage-ubuntu-focal-4 /var/lib/libvirt/images/storage-ubuntu-focal-4_vdb_storage vdb --persistent --subdriver qcow2
# sudo virsh attach-disk storage-ubuntu-focal-4 /var/lib/libvirt/images/storage-ubuntu-focal-4_vdc_storage vdc --persistent --subdriver qcow2
# sudo virsh attach-disk storage-ubuntu-focal-4 /var/lib/libvirt/images/storage-ubuntu-focal-4_vdd_storage vdd --persistent --subdriver qcow2

sudo rm -rf /etc/apt/sources.list.d/kubernetes.list

sed -i 's/^AllowUsers ubuntu-focal$/AllowUsers ubuntu-focal root/' /etc/ssh/sshd_config
sed -i 's/^PermitRootLogin no$/PermitRootLogin yes/' /etc/ssh/sshd_config

systemctl reload ssh
systemctl restart ssh


sudo apt update
sudo apt -y install ca-certificates curl gnupg lsb-release

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

sudo apt update
sudo apt -y install docker-ce docker-ce-cli

(
  set -x; cd "$(mktemp -d)" &&
  curl --silent --remote-name --location https://github.com/ceph/ceph/raw/quincy/src/cephadm/cephadm

  chmod +x cephadm

  ./cephadm add-repo --release quincy

  ./cephadm install

  ./cephadm install ceph-common

   sudo mkdir -p /etc/ceph
 )

cephadm bootstrap --mon-ip `hostname -I | awk '{print $1}'`

ceph orch device ls
ceph orch apply osd --all-available-devices
ceph osd tree
ceph -s
ceph osd dump | grep 'replicated size'

ceph config set global mon_allow_pool_size_one true

ceph osd pool set .mgr size 2 --yes-i-really-mean-it
ceph osd pool set .mgr size 1 --yes-i-really-mean-it
ceph osd pool set .mgr min_size 1

ceph osd pool create rbd 64 64 replicated
ceph osd pool set rbd min_size 1
ceph osd pool set rbd size 2 --yes-i-really-mean-it
ceph osd pool set rbd size 1 --yes-i-really-mean-it


rbd pool init rbd
ceph osd pool application enable rbd rbd

ceph -s

ceph health mute POOL_NO_REDUNDANCY

ceph -s
rbd create rbd0 --size 1024  --image-feature layering
rbd create rbd1 --size 1024  --image-feature layering
rbd ls -l

# ceph config set global mon_allow_pool_delete true
