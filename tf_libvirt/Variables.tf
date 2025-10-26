variable "fs_share" {
  type    = string
  default = "/data/k8s_cluster/fs_shared"
}

variable "fs_share_disk_size" {
  type    = number
  default = 20 * 1024 * 1024 * 1024
}

variable "ssh_port" {
  type    = number
  default = 22
}

variable "network_name" {
  type    = string
  default = "default"
}

variable "runtime_linux_os" {
  type = string
}

locals {

  ssh_prv_key = pathexpand("~/.ssh/id_rsa")
  ssh_pub_key = pathexpand("~/.ssh/id_rsa.pub")

  etc_hosts_extra_script_path = "/usr/local/bin/etc_hosts_extra.sh"
  k8s_kubeadm_script_path     = "/usr/local/bin/kubeadm_script.sh"

  # Run k8s_cluster_libvirt_terraform/images/download_cloud_images.sh
  cloud_images_dir = "../images"
  cloud_images = {
    ubuntu       = "${local.cloud_images_dir}/jammy-server-cloudimg-amd64.img",
    #ubuntu       = "${local.cloud_images_dir}/noble-server-cloudimg-amd64.img",
    fedora       = "${local.cloud_images_dir}/Fedora-Cloud-Base-Generic-42-1.1.x86_64.qcow2"
    rocky9       = "${local.cloud_images_dir}/Rocky-9-GenericCloud-Base.latest.x86_64.qcow2"
    ubuntu-focal = "${local.cloud_images_dir}/focal-server-cloudimg-amd64.img"
  }

  etcdnode    = "etcdnode"
  k8scpnode   = "k8scpnode"
  k8swrknode  = "k8swrknode"
  storagenode = "storagenode"

  VMs = [
    { os = "ubuntu", type = local.etcdnode, idx = 1, hostname = "etcd1", ip = "192.168.100.221", mac = "52:53:00:b1:5b:ff" },
    { os = "ubuntu", type = local.etcdnode, idx = 2, hostname = "etcd2", ip = "192.168.100.222", mac = "52:53:00:b2:4b:ff" },
    { os = "ubuntu", type = local.etcdnode, idx = 3, hostname = "etcd3", ip = "192.168.100.223", mac = "52:53:00:b3:6b:ff" },

    { os = "ubuntu", type = local.k8scpnode, idx = 1, hostname = "k8scp-ubuntu-1", ip = "192.168.100.210", mac = "52:53:00:b1:5b:fc" },
    { os = "ubuntu", type = local.k8scpnode, idx = 2, hostname = "k8scp-ubuntu-2", ip = "192.168.100.211", mac = "52:53:00:b1:5b:fb" },
    { os = "ubuntu", type = local.k8scpnode, idx = 3, hostname = "k8scp-ubuntu-3", ip = "192.168.100.212", mac = "52:53:00:b1:1b:fa" },

    { os = "ubuntu", type = local.k8swrknode, idx = 1, hostname = "k8swr-ubuntu-1", ip = "192.168.100.239", mac = "52:53:00:2a:06:31" },
    { os = "fedora", type = local.k8swrknode, idx = 2, hostname = "k8swr-fedora-2", ip = "192.168.100.226", mac = "52:53:00:41:ce:8b" },
    { os = "rocky9", type = local.k8swrknode, idx = 3, hostname = "k8swr-rocky9-3", ip = "192.168.100.249", mac = "52:53:00:ba:f1:ca" },
    { os = "ubuntu-focal", type = local.storagenode, idx = 4, hostname = "storage-ubuntu-focal-4", ip = "192.168.100.229", mac = "52:53:00:d6:f6:25" },
  ]

  vm_spec = {
    etcdnode = {
      prefix   = "etcd",
      vol_size = 80 * 1024 * 1024 * 1024,
      vcpu     = 4,
      vmem     = 2096,
    },
    k8scpnode = {
      prefix   = "k8scp",
      vol_size = 80 * 1024 * 1024 * 1024,
      vcpu     = 4,
      vmem     = 4096,
    },
    k8swrknode = {
      prefix   = "k8swr",
      vol_size = 80 * 1024 * 1024 * 1024,
      vcpu     = 4,
      vmem     = 2096,
    },
    storagenode = {
      prefix   = "storage",
      vol_size = 80 * 1024 * 1024 * 1024,
      vcpu     = 2,
      vmem     = 2096,
    }
  }

  # TimeZone of the VM: /usr/share/zoneinfo/
  timezone = "US/Eastern"

  network_name = var.network_name
  # The sshd port of the VM"
  ssh_port = var.ssh_port

}
